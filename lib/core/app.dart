import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/bloc/search/search_bloc.dart';
import 'package:movie_browser/core/service_provider.dart';
import 'package:movie_browser/l10n/app_localizations.dart';
import 'package:movie_browser/screens/favorites_screen/favorites_screen.dart';
import 'package:movie_browser/screens/search_screen/search_screen.dart';
import 'package:movie_browser/screens/settings_screen/settings_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  static const _screens = [SearchScreen(), FavoritesScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => getIt<SearchBloc>(),
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: l10n.searchTab,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite),
              label: l10n.favoritesTab,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: l10n.settingsTab,
            ),
          ],
        ),
      ),
    );
  }
}
