// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';
part 'movie.g.dart';

@freezed
abstract class Movie with _$Movie {
  const factory Movie({
    @JsonKey(name: 'Title', defaultValue: '') required String title,
    @JsonKey(name: 'Year', defaultValue: '') required String year,
    @JsonKey(defaultValue: '') required String imdbID,
    @JsonKey(name: 'Type', defaultValue: '') required String type,
    @JsonKey(name: 'Poster', defaultValue: '') required String poster,
    @JsonKey(name: 'Plot') @Default('') String plot,
    @JsonKey(name: 'Director') @Default('') String director,
    @JsonKey(name: 'Actors') @Default('') String actors,
    @JsonKey(name: 'Genre') @Default('') String genre,
    @JsonKey(name: 'Runtime') @Default('') String runtime,
    @JsonKey(name: 'Rated') @Default('') String rated,
    @Default('') String imdbRating,
  }) = _Movie;

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
}
