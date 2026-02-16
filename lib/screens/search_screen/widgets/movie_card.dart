import 'package:flutter/material.dart';
import 'package:movie_browser/core/models/movie.dart';
import 'package:movie_browser/core/service_provider.dart';
import 'package:movie_browser/l10n/app_localizations.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dbService = localDatabaseService;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: movie.poster != 'N/A'
                ? Image.network(
                    movie.poster,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 80,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.movie, size: 40),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(l10n.yearLabel(movie.year)),
                  const SizedBox(height: 4),
                  Text(l10n.typeLabel(movie.type)),
                ],
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: dbService.favoritesListenable,
            builder: (context, box, _) {
              final isFav = dbService.isFavorite(movie.imdbID);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : null,
                ),
                onPressed: () {
                  if (isFav) {
                    dbService.removeFavorite(movie.imdbID);
                  } else {
                    dbService.addFavorite(movie);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
