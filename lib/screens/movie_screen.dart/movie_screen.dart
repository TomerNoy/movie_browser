import 'package:flutter/material.dart';
import 'package:movie_browser/core/models/movie.dart';
import 'package:movie_browser/l10n/app_localizations.dart';

class MovieScreen extends StatelessWidget {
  const MovieScreen({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  l10n.yearLabel(movie.year),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  l10n.typeLabel(movie.type),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Image.network(movie.poster, width: 200, height: 300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
