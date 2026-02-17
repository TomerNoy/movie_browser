import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/bloc/search/search_event.dart';
import 'package:movie_browser/bloc/search/search_state.dart';
import 'package:movie_browser/core/models/result.dart';
import 'package:movie_browser/services/http_service.dart';
import 'package:movie_browser/services/local_database_service.dart';
import 'package:movie_browser/services/logger_service.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HttpService httpService;
  final LocalDatabaseService dbService;
  final LoggerService logger;

  SearchBloc({
    required this.httpService,
    required this.dbService,
    required this.logger,
  }) : super(SearchInitial()) {
    on<SearchQuerySubmitted>(_onQuerySubmitted);
    on<SearchNextPageRequested>(_onNextPageRequested);
    on<SearchResetRequested>(_onSearchReset);
  }

  void _onSearchReset(SearchResetRequested event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }

  Future<void> _onQuerySubmitted(
    SearchQuerySubmitted event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    logger.info('Searching for movies: ${event.query}');

    await dbService.addHistoryEntry(event.query);

    final result = await httpService.queryMovies(event.query);

    if (result.isSuccess) {
      final data = result.data!;
      if (data.movies.isEmpty) {
        emit(SearchEmpty());
      } else {
        logger.info(
          'Movies fetched: ${data.movies.length}/${data.totalResults}',
        );
        emit(
          SearchSuccess(
            movies: data.movies,
            totalResults: data.totalResults,
            currentPage: 1,
            query: event.query,
          ),
        );
      }
    } else {
      logger.error('Search failed: ${result.error}');
      emit(SearchError(result.errorType ?? result.error!.toErrorType()));
    }
  }

  Future<void> _onNextPageRequested(
    SearchNextPageRequested event,
    Emitter<SearchState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SearchSuccess ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    logger.info('Loading page $nextPage for: ${currentState.query}');

    final result = await httpService.queryMovies(
      currentState.query,
      page: nextPage,
    );

    if (result.isSuccess) {
      final data = result.data!;
      final allMovies = [...currentState.movies, ...data.movies];
      emit(
        SearchSuccess(
          movies: allMovies,
          totalResults: data.totalResults,
          currentPage: nextPage,
          query: currentState.query,
        ),
      );
    } else {
      logger.error('Pagination failed: ${result.error}');
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }
}

extension _StringErrorType on String {
  AppErrorType toErrorType() {
    if (contains('Too many results')) {
      return AppErrorType.tooManyResults;
    }
    if (contains('not found')) {
      return AppErrorType.noResults;
    }
    if (contains('Network') || contains('Socket') || contains('Connection')) {
      return AppErrorType.network;
    }
    return AppErrorType.unknown;
  }
}
