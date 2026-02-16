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
  String get searchScreenTitle => 'Movies Browser';

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
  String get favoritesEmpty => 'Favorites';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get changeLanguageSubtitle => 'Change the language of the app';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHebrew => 'Hebrew';
}
