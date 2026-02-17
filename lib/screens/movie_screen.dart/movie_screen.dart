import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_browser/bloc/movie_details/movie_details_cubit.dart';
import 'package:movie_browser/bloc/movie_details/movie_details_state.dart';
import 'package:movie_browser/core/models/movie.dart';
import 'package:movie_browser/core/models/result.dart';
import 'package:movie_browser/core/service_provider.dart';
import 'package:movie_browser/l10n/app_localizations.dart';

class MovieScreen extends StatelessWidget {
  const MovieScreen({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MovieDetailsCubit>()..loadDetails(movie.imdbID),
      child: _MovieScreenContent(movie: movie),
    );
  }
}

class _MovieScreenContent extends StatelessWidget {
  const _MovieScreenContent({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dbService = localDatabaseService;

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading || state is MovieDetailsInitial) {
            return _buildBasicView(
              context,
              l10n,
              movie,
              dbService,
              isLoading: true,
            );
          }

          if (state is MovieDetailsLoaded) {
            return _buildDetailView(
              context,
              l10n,
              state.movie,
              dbService,
              state.fromCache,
            );
          }

          if (state is MovieDetailsError) {
            return _buildErrorView(context, l10n, state.errorType, dbService);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBasicView(
    BuildContext context,
    AppLocalizations l10n,
    Movie movie,
    localDatabaseService, {
    bool isLoading = false,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: _buildPoster(movie)),
          const SizedBox(height: 16),
          Center(
            child: _buildFavoriteButton(
              context,
              l10n,
              movie,
              localDatabaseService,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              l10n.yearLabel(movie.year),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              l10n.typeLabel(movie.type),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (isLoading) ...[
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailView(
    BuildContext context,
    AppLocalizations l10n,
    Movie detailedMovie,
    localDatabaseService,
    bool fromCache,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (fromCache)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 18, color: Colors.orange),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      l10n.cachedDataNotice,
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          Center(child: _buildPoster(detailedMovie)),
          const SizedBox(height: 16),
          Center(
            child: _buildFavoriteButton(
              context,
              l10n,
              detailedMovie,
              localDatabaseService,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(context, l10n, detailedMovie),
          if (detailedMovie.plot.isNotEmpty && detailedMovie.plot != 'N/A') ...[
            const SizedBox(height: 16),
            _buildPlotSection(context, l10n, detailedMovie.plot),
          ],
        ],
      ),
    );
  }

  Widget _buildPoster(Movie movie) {
    if (movie.poster.isNotEmpty && movie.poster != 'N/A') {
      return Semantics(
        label: movie.title,
        image: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: movie.poster,
            width: 200,
            height: 300,
            fit: BoxFit.cover,
            placeholder: (_, _) => _buildPosterPlaceholder(),
            errorWidget: (_, _, _) => _buildPosterPlaceholder(),
          ),
        ),
      );
    }
    return Semantics(
      label: movie.title,
      image: true,
      child: _buildPosterPlaceholder(),
    );
  }

  Widget _buildPosterPlaceholder() {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.movie, size: 60),
    );
  }

  Widget _buildFavoriteButton(
    BuildContext context,
    AppLocalizations l10n,
    Movie movie,
    localDatabaseService,
  ) {
    return ValueListenableBuilder(
      valueListenable: localDatabaseService.favoritesListenable,
      builder: (context, box, _) {
        final isFav = localDatabaseService.isFavorite(movie.imdbID);
        return FilledButton.icon(
          onPressed: () {
            if (isFav) {
              localDatabaseService.removeFavorite(movie.imdbID);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.removedFromFavorites)),
              );
            } else {
              localDatabaseService.addFavorite(movie);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.addedToFavorites)));
            }
          },
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          label: Text(isFav ? l10n.removeFromFavorites : l10n.addToFavorites),
          style: FilledButton.styleFrom(
            backgroundColor: isFav ? Colors.red : null,
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    AppLocalizations l10n,
    Movie movie,
  ) {
    final items = <Widget>[];

    items.add(_infoRow(Icons.calendar_today, l10n.yearLabel(movie.year)));
    items.add(_infoRow(Icons.category, l10n.typeLabel(movie.type)));

    if (movie.runtime.isNotEmpty && movie.runtime != 'N/A') {
      items.add(_infoRow(Icons.timer, l10n.runtimeLabel(movie.runtime)));
    }
    if (movie.genre.isNotEmpty && movie.genre != 'N/A') {
      items.add(_infoRow(Icons.local_movies, l10n.genreLabel(movie.genre)));
    }
    if (movie.rated.isNotEmpty && movie.rated != 'N/A') {
      items.add(_infoRow(Icons.verified, l10n.ratedLabel(movie.rated)));
    }
    if (movie.imdbRating.isNotEmpty && movie.imdbRating != 'N/A') {
      items.add(_infoRow(Icons.star, l10n.ratingLabel(movie.imdbRating)));
    }
    if (movie.director.isNotEmpty && movie.director != 'N/A') {
      items.add(_infoRow(Icons.person, l10n.directorLabel(movie.director)));
    }
    if (movie.actors.isNotEmpty && movie.actors != 'N/A') {
      items.add(_infoRow(Icons.people, l10n.actorsLabel(movie.actors)));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildPlotSection(
    BuildContext context,
    AppLocalizations l10n,
    String plot,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.plotLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(plot, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    AppLocalizations l10n,
    AppErrorType errorType,
    localDatabaseService,
  ) {
    final message = _errorMessage(l10n, errorType);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                context.read<MovieDetailsCubit>().loadDetails(movie.imdbID);
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  String _errorMessage(AppLocalizations l10n, AppErrorType errorType) {
    switch (errorType) {
      case AppErrorType.network:
        return l10n.errorNetwork;
      case AppErrorType.noResults:
        return l10n.errorLoadingDetails;
      case AppErrorType.tooManyResults:
        return l10n.errorTooManyResults;
      case AppErrorType.api:
        return l10n.errorApi;
      case AppErrorType.unknown:
        return l10n.errorUnknown;
    }
  }
}
