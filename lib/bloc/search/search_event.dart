import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_event.freezed.dart';

@freezed
sealed class SearchEvent with _$SearchEvent {
  const factory SearchEvent.querySubmitted(String query) =
      SearchQuerySubmitted;
  const factory SearchEvent.nextPageRequested() = SearchNextPageRequested;
  const factory SearchEvent.searchReset() = SearchResetRequested;
}
