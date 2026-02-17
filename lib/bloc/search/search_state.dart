import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_browser/core/models/movie.dart';
import 'package:movie_browser/core/models/result.dart';

part 'search_state.freezed.dart';

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState.initial() = SearchInitial;
  const factory SearchState.loading() = SearchLoading;
  const factory SearchState.empty() = SearchEmpty;
  const factory SearchState.success({
    required List<Movie> movies,
    required int totalResults,
    required int currentPage,
    required String query,
    @Default(false) bool isLoadingMore,
  }) = SearchSuccess;
  const factory SearchState.error(AppErrorType errorType) = SearchError;
}

extension SearchSuccessHelpers on SearchSuccess {
  bool get hasMore => movies.length < totalResults;
}
