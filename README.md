# Movie Browser

A Flutter mobile app that allows users to search for movies using the public OMDb API, view detailed information, and manage a list of favorite movies — all with full localization support.

## How to Run

1. **Prerequisites**: Flutter SDK (3.10+), Dart SDK
2. **Clone the repository**:
   ```bash
   git clone <repo-url>
   cd movie_browser
   ```
3. **Set up the API key**: Create a `.env` file in the project root with your OMDb API key:
   ```
   OMDb_API_KEY=your_api_key_here
   ```
   You can get a free key at [omdbapi.com](https://www.omdbapi.com/apikey.aspx).
4. **Install dependencies**:
   ```bash
   flutter pub get
   ```
5. **Run the app**:
   ```bash
   flutter run
   ```

## Architecture

### State Management

- **BLoC** (`flutter_bloc`) for all feature-level state: search results with pagination (`SearchBloc`) and movie details with cache fallback (`MovieDetailsCubit`).
- **flutter_hooks** for local UI state in the search screen (text controllers, listenable subscriptions).

### Local Storage

- **Hive** (`hive_flutter`) with three boxes:
  - `favorites` — persisted favorite movies
  - `movie_cache` — cached full movie details for offline fallback
  - `search_history` — recent search queries

### Dependency Injection

- **GetIt** as a service locator. All services and BLoCs are registered in `service_provider.dart` for clean testability and separation.

### Networking

- **Dio** for HTTP requests to the OMDb API, with typed error handling (`AppErrorType`) so the UI can display localized error messages without hardcoded strings.

### Localization

- **intl** with Flutter's built-in `gen-l10n` from ARB files. Supports English and Hebrew (RTL). All user-facing strings — including error messages — come from localization.

### Project Structure

```
lib/
├── bloc/                    # BLoC / Cubit classes
│   ├── search/              # Search feature (events, states, bloc)
│   └── movie_details/       # Movie details (cubit, states)
├── core/
│   ├── models/              # Data models (Movie, Result, SearchResponse)
│   ├── app.dart             # Main app shell with bottom nav
│   ├── locale_notifier.dart # Locale state
│   ├── service_provider.dart# GetIt DI setup
│   └── constants/
├── l10n/                    # ARB files + generated localizations
├── screens/
│   ├── search_screen/       # Search + results + history
│   ├── movie_screen.dart/   # Movie details screen
│   ├── favorites_screen/    # Saved favorites
│   └── settings_screen/     # Language selector
└── services/
    ├── http_service.dart    # OMDb API client
    ├── local_database_service.dart  # Hive operations
    └── logger_service.dart  # Logging utility
```

### Key Design Decisions

- **Typed errors via `AppErrorType`**: The service layer classifies errors (network, noResults, api, unknown) so BLoCs emit error types rather than raw strings. The UI maps these to localized messages.
- **Cache fallback on details screen**: If the network request for movie details fails, the app attempts to show the last cached version from Hive before showing an error.
- **Pagination via infinite scroll**: The OMDb API returns 10 results per page. The `SearchBloc` accumulates results across pages. The UI triggers the next page load when the user scrolls towards the bottom.
- **Search history**: Stored locally in Hive, reactive via `ValueListenableBuilder`. Shown when the search screen is in its initial state. Supports removing individual entries and clearing all.

## Not Implemented

- **JSON assets for localization**: ARB files were used instead of JSON assets. ARB provides type-safe, auto-generated localization classes and better IDE support. JSON can be converted to ARB via a simple script if needed.