// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Movie Browser';

  @override
  String get searchTab => 'Search';

  @override
  String get favoritesTab => 'Favorites';

  @override
  String get searchScreenTitle => 'Movie Browser';

  @override
  String get searchHint => 'Search for a movie';

  @override
  String get settingsTab => 'Settings';

  @override
  String get searchPrompt => 'Search for a movie';

  @override
  String yearLabel(String year) {
    return 'Year: $year';
  }

  @override
  String typeLabel(String type) {
    return 'Type: $type';
  }

  @override
  String get favoritesEmpty => 'No favorite movies yet';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get changeLanguageSubtitle => 'Change the language of the app';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHebrew => 'Hebrew';

  @override
  String get errorNetwork =>
      'A network error occurred. Please check your connection.';

  @override
  String get errorNoResults => 'No movies found. Try a different search.';

  @override
  String get errorTooManyResults =>
      'Too many results. Please enter a more specific search term.';

  @override
  String get errorApi => 'Something went wrong. Please try again.';

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String get errorLoadingDetails => 'Failed to load movie details.';

  @override
  String directorLabel(String director) {
    return 'Director: $director';
  }

  @override
  String actorsLabel(String actors) {
    return 'Actors: $actors';
  }

  @override
  String get plotLabel => 'Plot';

  @override
  String ratingLabel(String rating) {
    return 'IMDb Rating: $rating';
  }

  @override
  String runtimeLabel(String runtime) {
    return 'Runtime: $runtime';
  }

  @override
  String genreLabel(String genre) {
    return 'Genre: $genre';
  }

  @override
  String ratedLabel(String rated) {
    return 'Rated: $rated';
  }

  @override
  String get cachedDataNotice => 'Showing cached data (offline)';

  @override
  String get searchHistory => 'Recent Searches';

  @override
  String get clearHistory => 'Clear All';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get retry => 'Retry';

  @override
  String get movieDetailsTitle => 'Movie Details';

  @override
  String get search => 'Search';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get clearSearchHistory => 'Remove from history';

  @override
  String get viewMovieDetails => 'View movie details';
}
