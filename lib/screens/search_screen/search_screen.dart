import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:movie_browser/bloc/search/search_bloc.dart';
import 'package:movie_browser/bloc/search/search_event.dart';
import 'package:movie_browser/bloc/search/search_state.dart';
import 'package:movie_browser/l10n/app_localizations.dart';
import 'package:movie_browser/screens/movie_screen.dart/movie_screen.dart';
import 'package:movie_browser/screens/search_screen/widgets/movie_card.dart';

class SearchScreen extends HookWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final queryController = useTextEditingController();
    useListenable(queryController);
    final searchEnabled = queryController.text.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.searchScreenTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.searchHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  controller: queryController,
                ),
              ),
              IconButton(
                onPressed: searchEnabled
                    ? () => context.read<SearchBloc>().add(
                        SearchQuerySubmitted(queryController.text),
                      )
                    : null,
                icon: const Icon(Icons.search),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return Center(child: Text(l10n.searchPrompt));
          }
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SearchError) {
            return Center(child: Text(state.message));
          }
          if (state is SearchSuccess) {
            return ListView.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieScreen(movie: movie),
                      ),
                    );
                  },
                  child: MovieCard(movie: movie),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
