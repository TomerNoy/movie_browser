import 'package:flutter/material.dart';
import 'package:movie_browser/core/service_provider.dart';
import 'package:movie_browser/l10n/app_localizations.dart';
import 'package:movie_browser/screens/movie_screen.dart/movie_screen.dart';
import 'package:movie_browser/screens/widgets/movie_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dbService = localDatabaseService;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTab)),
      body: ValueListenableBuilder(
        valueListenable: dbService.favoritesListenable,
        builder: (context, box, _) {
          final favorites = dbService.getFavorites();

          if (favorites.isEmpty) {
            return Center(child: Text(l10n.favoritesEmpty));
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final movie = favorites[index];
              return Semantics(
                label: '${movie.title}, ${l10n.viewMovieDetails}',
                button: true,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieScreen(movie: movie),
                      ),
                    );
                  },
                  child: MovieCard(movie: movie),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
