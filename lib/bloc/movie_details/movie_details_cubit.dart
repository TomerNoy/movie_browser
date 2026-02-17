import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/bloc/movie_details/movie_details_state.dart';
import 'package:movie_browser/core/models/result.dart';
import 'package:movie_browser/services/http_service.dart';
import 'package:movie_browser/services/local_database_service.dart';
import 'package:movie_browser/services/logger_service.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final HttpService httpService;
  final LocalDatabaseService dbService;
  final LoggerService logger;

  MovieDetailsCubit({
    required this.httpService,
    required this.dbService,
    required this.logger,
  }) : super(MovieDetailsInitial());

  Future<void> loadDetails(String imdbID) async {
    emit(MovieDetailsLoading());
    logger.info('Loading details for: $imdbID');

    final result = await httpService.getMovieDetails(imdbID);

    if (result.isSuccess) {
      final movie = result.data!;
      await dbService.cacheMovie(movie);
      logger.info('Movie details loaded: ${movie.title}');
      emit(MovieDetailsLoaded(movie: movie));
    } else {
      logger.warning('API failed, trying cache for: $imdbID');
      final cached = dbService.getCachedMovie(imdbID);
      if (cached != null) {
        logger.info('Showing cached details for: ${cached.title}');
        emit(MovieDetailsLoaded(movie: cached, fromCache: true));
      } else {
        logger.error('No cache available for: $imdbID');
        emit(MovieDetailsError(result.errorType ?? AppErrorType.unknown));
      }
    }
  }
}
