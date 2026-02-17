import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_browser/core/models/movie.dart';

class LocalDatabaseService {
  final HiveInterface hive;
  static const _favoritesBoxName = 'favorites';
  static const _movieCacheBoxName = 'movie_cache';
  static const _historyBoxName = 'search_history';

  LocalDatabaseService({required this.hive});

  Box get _favoritesBox => hive.box(_favoritesBoxName);
  Box get _movieCacheBox => hive.box(_movieCacheBoxName);
  Box get _historyBox => hive.box(_historyBoxName);

  Future<void> init() async {
    await hive.openBox(_favoritesBoxName);
    await hive.openBox(_movieCacheBoxName);
    await hive.openBox(_historyBoxName);
  }

  // --- Favorites ---

  ValueListenable<Box> get favoritesListenable => _favoritesBox.listenable();

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

  // --- Movie Cache ---

  Future<void> cacheMovie(Movie movie) async {
    await _movieCacheBox.put(movie.imdbID, movie.toJson());
  }

  Movie? getCachedMovie(String imdbID) {
    final json = _movieCacheBox.get(imdbID);
    if (json == null) return null;
    return Movie.fromJson(Map<String, dynamic>.from(json));
  }

  // --- Search History ---

  ValueListenable<Box> get historyListenable => _historyBox.listenable();

  Future<void> addHistoryEntry(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) return;

    final keys = _historyBox.keys.toList();
    for (final key in keys) {
      if (_historyBox.get(key) == normalized) {
        await _historyBox.delete(key);
        break;
      }
    }
    await _historyBox.add(normalized);
  }

  Future<void> removeHistoryEntry(String query) async {
    final keys = _historyBox.keys.toList();
    for (final key in keys) {
      if (_historyBox.get(key) == query) {
        await _historyBox.delete(key);
        break;
      }
    }
  }

  Future<void> clearHistory() async {
    await _historyBox.clear();
  }

  List<String> getHistory() {
    return _historyBox.values.cast<String>().toList().reversed.toList();
  }
}
