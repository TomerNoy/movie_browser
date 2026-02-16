import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_browser/core/models/movie.dart';

class LocalDatabaseService {
  final HiveInterface hive;
  static const _favoritesBoxName = 'favorites';

  LocalDatabaseService({required this.hive});

  Box get _favoritesBox => hive.box(_favoritesBoxName);

  Future<void> init() async {
    await hive.openBox(_favoritesBoxName);
  }

  ValueListenable<Box> get favoritesListenable =>
      _favoritesBox.listenable();

  Future<void> addFavorite(Movie movie) async {
    await _favoritesBox.put(movie.imdbID, movie.toJson());
  }

  Future<void> removeFavorite(String imdbID) async {
    await _favoritesBox.delete(imdbID);
  }

  bool isFavorite(String imdbID) {
    return _favoritesBox.containsKey(imdbID);
  }

  List<Movie> getFavorites() {
    return _favoritesBox.values
        .map((json) => Movie.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
}
