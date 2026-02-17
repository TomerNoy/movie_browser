import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movie_browser/bloc/search/search_bloc.dart';
import 'package:movie_browser/bloc/search/search_event.dart';
import 'package:movie_browser/bloc/search/search_state.dart';
import 'package:movie_browser/core/models/result.dart';
import 'package:movie_browser/core/service_provider.dart';
import 'package:movie_browser/l10n/app_localizations.dart';
import 'package:movie_browser/screens/movie_screen.dart/movie_screen.dart';
import 'package:movie_browser/screens/widgets/movie_card.dart';

class SearchScreen extends HookWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final queryController = useTextEditingController();
    useListenable(queryController);
    final searchEnabled = queryController.text.isNotEmpty;

    useEffect(() {
      if (!searchEnabled) {
        context.read<SearchBloc>().add(const SearchResetRequested());
      }
      return null;
    }, [searchEnabled]);

    void submitSearch() {
      if (queryController.text.trim().isNotEmpty) {
        context.read<SearchBloc>().add(
          SearchQuerySubmitted(queryController.text.trim()),
        );
        FocusScope.of(context).unfocus();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchScreenTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l10n.searchHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      suffixIcon: searchEnabled
                          ? Semantics(
                              label: l10n.clearSearch,
                              button: true,
                              child: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () => queryController.clear(),
                              ),
                            )
                          : null,
                    ),
                    controller: queryController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => submitSearch(),
                  ),
                ),
                const SizedBox(width: 4),
                Semantics(
                  label: l10n.search,
                  button: true,
                  child: IconButton(
                    onPressed: searchEnabled ? submitSearch : null,
                    icon: const Icon(Icons.search),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return _SearchHistoryView(
              onTapQuery: (query) {
                queryController.text = query;
                context.read<SearchBloc>().add(SearchQuerySubmitted(query));
                FocusScope.of(context).unfocus();
              },
            );
          }
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SearchEmpty) {
            return _buildMessage(
              context,
              l10n.errorNoResults,
              Icons.search_off,
            );
          }
          if (state is SearchError) {
            return _buildErrorView(context, l10n, state.errorType);
          }
          if (state is SearchSuccess) {
            return _SearchResultsList(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMessage(BuildContext context, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    AppLocalizations l10n,
    AppErrorType errorType,
  ) {
    final message = _errorMessage(l10n, errorType);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  String _errorMessage(AppLocalizations l10n, AppErrorType errorType) {
    switch (errorType) {
      case AppErrorType.network:
        return l10n.errorNetwork;
      case AppErrorType.noResults:
        return l10n.errorNoResults;
      case AppErrorType.tooManyResults:
        return l10n.errorTooManyResults;
      case AppErrorType.api:
        return l10n.errorApi;
      case AppErrorType.unknown:
        return l10n.errorUnknown;
    }
  }
}

class _SearchHistoryView extends StatelessWidget {
  const _SearchHistoryView({required this.onTapQuery});

  final void Function(String query) onTapQuery;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dbService = localDatabaseService;

    return ValueListenableBuilder(
      valueListenable: dbService.historyListenable,
      builder: (context, box, _) {
        final history = dbService.getHistory();

        if (history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  l10n.searchPrompt,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      l10n.searchHistory,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  TextButton(
                    onPressed: () => dbService.clearHistory(),
                    child: Text(l10n.clearHistory),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final query = history[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(query),
                    trailing: Semantics(
                      label: l10n.clearSearchHistory,
                      button: true,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => dbService.removeHistoryEntry(query),
                      ),
                    ),
                    onTap: () => onTapQuery(query),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SearchResultsList extends StatelessWidget {
  const _SearchResultsList({required this.state});

  final SearchSuccess state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 500 &&
            state.hasMore &&
            !state.isLoadingMore) {
          context.read<SearchBloc>().add(SearchNextPageRequested());
        }
        return false;
      },
      child: ListView.builder(
        itemCount: state.movies.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.movies.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final movie = state.movies[index];
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
      ),
    );
  }
}
