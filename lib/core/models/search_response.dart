import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_browser/core/models/movie.dart';

part 'search_response.freezed.dart';

@freezed
abstract class SearchResponse with _$SearchResponse {
  const factory SearchResponse({
    required List<Movie> movies,
    required int totalResults,
  }) = _SearchResponse;
}
