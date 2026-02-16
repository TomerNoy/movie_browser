import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/bloc/search/search_event.dart';
import 'package:movie_browser/bloc/search/search_state.dart';
import 'package:movie_browser/services/http_service.dart';
import 'package:movie_browser/services/logger_service.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HttpService httpService;
  final LoggerService logger;

  SearchBloc({required this.httpService, required this.logger})
    : super(SearchInitial()) {
    on<SearchQuerySubmitted>(_onQuerySubmitted);
  }

  Future<void> _onQuerySubmitted(
    SearchQuerySubmitted event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    logger.info('Searching for movies: ${event.query}');

    final result = await httpService.queryMovies(event.query);

    if (result.isSuccess) {
      logger.info('Movies fetched successfully: ${result.data?.length}');
      emit(SearchSuccess(result.data ?? []));
    } else {
      logger.error('Failed to fetch movies: ${result.error}');
      emit(SearchError(result.error ?? 'Unknown error'));
    }
  }
}
