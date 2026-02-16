// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'מסכם סרטים';

  @override
  String get searchTab => 'חיפוש';

  @override
  String get favoritesTab => 'מועדפים';

  @override
  String get searchScreenTitle => 'מסכם סרטים';

  @override
  String get searchHint => 'חפש סרט';

  @override
  String get settingsTab => 'הגדרות';

  @override
  String get searchPrompt => 'חפש סרט';

  @override
  String yearLabel(String year) {
    return 'שנת הוצאה: $year';
  }

  @override
  String typeLabel(String type) {
    return 'סוג: $type';
  }

  @override
  String get favoritesEmpty => 'אין סרטים במועדפים';

  @override
  String get changeLanguage => 'שינוי שפה';

  @override
  String get changeLanguageSubtitle => 'שנה את שפת האפליקציה';

  @override
  String get languageEnglish => 'אנגלית';

  @override
  String get languageHebrew => 'עברית';
}
