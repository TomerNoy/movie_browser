import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_browser/core/models/movie.dart';
import 'package:movie_browser/core/models/result.dart';

part 'movie_details_state.freezed.dart';

@freezed
sealed class MovieDetailsState with _$MovieDetailsState {
  const factory MovieDetailsState.initial() = MovieDetailsInitial;
  const factory MovieDetailsState.loading() = MovieDetailsLoading;
  const factory MovieDetailsState.loaded({
    required Movie movie,
    @Default(false) bool fromCache,
  }) = MovieDetailsLoaded;
  const factory MovieDetailsState.error(AppErrorType errorType) =
      MovieDetailsError;
}
