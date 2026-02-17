// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'דפדפן סרטים';

  @override
  String get searchTab => 'חיפוש';

  @override
  String get favoritesTab => 'מועדפים';

  @override
  String get searchScreenTitle => 'דפדפן סרטים';

  @override
  String get searchHint => 'חפש סרט';

  @override
  String get settingsTab => 'הגדרות';

  @override
  String get searchPrompt => 'חפש סרט';

  @override
  String yearLabel(String year) {
    return 'שנה: $year';
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

  @override
  String get errorNetwork => 'שגיאת רשת. אנא בדוק את החיבור שלך.';

  @override
  String get errorNoResults => 'לא נמצאו סרטים. נסה חיפוש אחר.';

  @override
  String get errorTooManyResults =>
      'יותר מדי תוצאות. נסה לחפש עם מילות חיפוש מדויקות יותר.';

  @override
  String get errorApi => 'משהו השתבש. אנא נסה שוב.';

  @override
  String get errorUnknown => 'אירעה שגיאה בלתי צפויה.';

  @override
  String get errorLoadingDetails => 'טעינת פרטי הסרט נכשלה.';

  @override
  String directorLabel(String director) {
    return 'במאי: $director';
  }

  @override
  String actorsLabel(String actors) {
    return 'שחקנים: $actors';
  }

  @override
  String get plotLabel => 'עלילה';

  @override
  String ratingLabel(String rating) {
    return 'דירוג IMDb: $rating';
  }

  @override
  String runtimeLabel(String runtime) {
    return 'משך: $runtime';
  }

  @override
  String genreLabel(String genre) {
    return 'ז\'אנר: $genre';
  }

  @override
  String ratedLabel(String rated) {
    return 'דירוג: $rated';
  }

  @override
  String get cachedDataNotice => 'מציג נתונים שמורים (לא מקוון)';

  @override
  String get searchHistory => 'חיפושים אחרונים';

  @override
  String get clearHistory => 'נקה הכל';

  @override
  String get addToFavorites => 'הוסף למועדפים';

  @override
  String get removeFromFavorites => 'הסר מהמועדפים';

  @override
  String get addedToFavorites => 'נוסף למועדפים';

  @override
  String get removedFromFavorites => 'הוסר מהמועדפים';

  @override
  String get retry => 'נסה שוב';

  @override
  String get movieDetailsTitle => 'פרטי סרט';

  @override
  String get search => 'חפש';

  @override
  String get clearSearch => 'נקה חיפוש';

  @override
  String get clearSearchHistory => 'הסר מהיסטוריה';

  @override
  String get viewMovieDetails => 'צפה בפרטי הסרט';
}
