import 'package:cached_network_image/cached_network_image.dart';
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
            child: _buildPoster(),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
              return Semantics(
                label: isFav ? l10n.removeFromFavorites : l10n.addToFavorites,
                button: true,
                child: IconButton(
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPoster() {
    if (movie.poster.isNotEmpty && movie.poster != 'N/A') {
      return Semantics(
        label: movie.title,
        image: true,
        child: CachedNetworkImage(
          imageUrl: movie.poster,
          width: 80,
          height: 120,
          fit: BoxFit.cover,
          placeholder: (_, _) => _posterPlaceholder(),
          errorWidget: (_, _, _) => _posterPlaceholder(),
        ),
      );
    }
    return Semantics(
      label: movie.title,
      image: true,
      child: _posterPlaceholder(),
    );
  }

  Widget _posterPlaceholder() {
    return Container(
      width: 80,
      height: 120,
      color: Colors.grey[300],
      child: Semantics(
        excludeSemantics: true,
        child: const Icon(Icons.movie, size: 40),
      ),
    );
  }
}
