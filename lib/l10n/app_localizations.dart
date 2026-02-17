import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('he'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Movie Browser'**
  String get appTitle;

  /// Label for the search tab in bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTab;

  /// Label for the favorites tab in bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTab;

  /// Title shown in the search screen app bar
  ///
  /// In en, this message translates to:
  /// **'Movie Browser'**
  String get searchScreenTitle;

  /// Hint text inside the search input field
  ///
  /// In en, this message translates to:
  /// **'Search for a movie'**
  String get searchHint;

  /// Label for the settings tab in bottom navigation
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTab;

  /// Prompt text shown when no search has been performed yet
  ///
  /// In en, this message translates to:
  /// **'Search for a movie'**
  String get searchPrompt;

  /// Displays the release year of a movie
  ///
  /// In en, this message translates to:
  /// **'Year: {year}'**
  String yearLabel(String year);

  /// Displays the type of a title (movie, series, episode)
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String typeLabel(String type);

  /// Message shown when the favorites list is empty
  ///
  /// In en, this message translates to:
  /// **'No favorite movies yet'**
  String get favoritesEmpty;

  /// Title for the language setting option
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Subtitle for the language setting option
  ///
  /// In en, this message translates to:
  /// **'Change the language of the app'**
  String get changeLanguageSubtitle;

  /// Label for the English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Label for the Hebrew language option
  ///
  /// In en, this message translates to:
  /// **'Hebrew'**
  String get languageHebrew;

  /// Error message shown when a network error occurs
  ///
  /// In en, this message translates to:
  /// **'A network error occurred. Please check your connection.'**
  String get errorNetwork;

  /// Error message shown when a search returns no results
  ///
  /// In en, this message translates to:
  /// **'No movies found. Try a different search.'**
  String get errorNoResults;

  /// Error message shown when the search query is too broad
  ///
  /// In en, this message translates to:
  /// **'Too many results. Please enter a more specific search term.'**
  String get errorTooManyResults;

  /// Error message shown when an API error occurs
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorApi;

  /// Error message shown for unknown errors
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorUnknown;

  /// Error message shown when movie details fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load movie details.'**
  String get errorLoadingDetails;

  /// Displays the director of a movie
  ///
  /// In en, this message translates to:
  /// **'Director: {director}'**
  String directorLabel(String director);

  /// Displays the actors of a movie
  ///
  /// In en, this message translates to:
  /// **'Actors: {actors}'**
  String actorsLabel(String actors);

  /// Header for the plot section on the movie details screen
  ///
  /// In en, this message translates to:
  /// **'Plot'**
  String get plotLabel;

  /// Displays the IMDb rating of a movie
  ///
  /// In en, this message translates to:
  /// **'IMDb Rating: {rating}'**
  String ratingLabel(String rating);

  /// Displays the runtime of a movie
  ///
  /// In en, this message translates to:
  /// **'Runtime: {runtime}'**
  String runtimeLabel(String runtime);

  /// Displays the genre of a movie
  ///
  /// In en, this message translates to:
  /// **'Genre: {genre}'**
  String genreLabel(String genre);

  /// Displays the content rating of a movie
  ///
  /// In en, this message translates to:
  /// **'Rated: {rated}'**
  String ratedLabel(String rated);

  /// Banner message shown when displaying cached data while offline
  ///
  /// In en, this message translates to:
  /// **'Showing cached data (offline)'**
  String get cachedDataNotice;

  /// Header for the recent search history section
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get searchHistory;

  /// Button label to clear all search history
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearHistory;

  /// Button label to add a movie to favorites
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// Button label to remove a movie from favorites
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// Snackbar message shown after a movie is added to favorites
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// Snackbar message shown after a movie is removed from favorites
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// Button label to retry a failed operation
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Title for the movie details screen
  ///
  /// In en, this message translates to:
  /// **'Movie Details'**
  String get movieDetailsTitle;

  /// Button label for search action
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Button label to clear search input
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// Button label to remove a search query from history
  ///
  /// In en, this message translates to:
  /// **'Remove from history'**
  String get clearSearchHistory;

  /// Semantic label for tappable movie card
  ///
  /// In en, this message translates to:
  /// **'View movie details'**
  String get viewMovieDetails;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'he':
      return AppLocalizationsHe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
