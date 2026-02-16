abstract class SearchEvent {}

class SearchQuerySubmitted extends SearchEvent {
  final String query;

  SearchQuerySubmitted(this.query);
}
