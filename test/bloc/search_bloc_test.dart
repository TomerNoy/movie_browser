import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_browser/bloc/search/search_bloc.dart';
import 'package:movie_browser/bloc/search/search_event.dart';
import 'package:movie_browser/bloc/search/search_state.dart';
import 'package:movie_browser/core/models/movie.dart';
import 'package:movie_browser/core/models/result.dart';
import 'package:movie_browser/core/models/search_response.dart';
import 'package:movie_browser/services/http_service.dart';
import 'package:movie_browser/services/local_database_service.dart';
import 'package:movie_browser/services/logger_service.dart';

class MockHttpService extends Mock implements HttpService {}

class MockLocalDatabaseService extends Mock implements LocalDatabaseService {}

class MockLoggerService extends Mock implements LoggerService {}

void main() {
  late MockHttpService mockHttpService;
  late MockLocalDatabaseService mockDbService;
  late MockLoggerService mockLogger;

  final testMovies = [
    Movie(
      title: 'Batman Begins',
      year: '2005',
      imdbID: 'tt0372784',
      type: 'movie',
      poster: 'https://example.com/poster.jpg',
    ),
    Movie(
      title: 'The Batman',
      year: '2022',
      imdbID: 'tt1877830',
      type: 'movie',
      poster: 'https://example.com/poster2.jpg',
    ),
  ];

  setUp(() {
    mockHttpService = MockHttpService();
    mockDbService = MockLocalDatabaseService();
    mockLogger = MockLoggerService();
  });

  SearchBloc buildBloc() => SearchBloc(
    httpService: mockHttpService,
    dbService: mockDbService,
    logger: mockLogger,
  );

  group('SearchBloc', () {
    // test the initial state of the bloc
    test('initial state is SearchInitial', () {
      final bloc = buildBloc();
      expect(bloc.state, isA<SearchInitial>());
      bloc.close();
    });

    // test the state when the search succeeds
    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchSuccess] when search succeeds',
      setUp: () {
        when(
          () => mockDbService.addHistoryEntry(any()),
        ).thenAnswer((_) async {});
        when(() => mockHttpService.queryMovies('batman', page: 1)).thenAnswer(
          (_) async => Result.success(
            SearchResponse(movies: testMovies, totalResults: 2),
          ),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(SearchQuerySubmitted('batman')),
      expect: () => [
        isA<SearchLoading>(),
        isA<SearchSuccess>()
            .having((s) => s.movies.length, 'movies count', 2)
            .having((s) => s.totalResults, 'totalResults', 2)
            .having((s) => s.currentPage, 'currentPage', 1),
      ],
      verify: (_) {
        verify(() => mockDbService.addHistoryEntry('batman')).called(1);
      },
    );

    // test the state when the search fails with no results
    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchEmpty] when no results',
      setUp: () {
        when(
          () => mockDbService.addHistoryEntry(any()),
        ).thenAnswer((_) async {});
        when(
          () => mockHttpService.queryMovies('xyznonexistent', page: 1),
        ).thenAnswer(
          (_) async =>
              Result.failure('Movie not found!', AppErrorType.noResults),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(SearchQuerySubmitted('xyznonexistent')),
      expect: () => [
        isA<SearchLoading>(),
        isA<SearchError>().having(
          (s) => s.errorType,
          'errorType',
          AppErrorType.noResults,
        ),
      ],
    );

    // test the state when the search fails with a network error
    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchError] on network error',
      setUp: () {
        when(
          () => mockDbService.addHistoryEntry(any()),
        ).thenAnswer((_) async {});
        when(() => mockHttpService.queryMovies('batman', page: 1)).thenAnswer(
          (_) async => Result.failure('Network error', AppErrorType.network),
        );
      },
      build: buildBloc,
      act: (bloc) => bloc.add(SearchQuerySubmitted('batman')),
      expect: () => [
        isA<SearchLoading>(),
        isA<SearchError>().having(
          (s) => s.errorType,
          'errorType',
          AppErrorType.network,
        ),
      ],
    );

    // test the state when the next page is loaded and the movies are appended
    blocTest<SearchBloc, SearchState>(
      'loads next page and appends movies',
      setUp: () {
        when(
          () => mockDbService.addHistoryEntry(any()),
        ).thenAnswer((_) async {});
        when(() => mockHttpService.queryMovies('batman', page: 1)).thenAnswer(
          (_) async => Result.success(
            SearchResponse(movies: [testMovies[0]], totalResults: 2),
          ),
        );
        when(() => mockHttpService.queryMovies('batman', page: 2)).thenAnswer(
          (_) async => Result.success(
            SearchResponse(movies: [testMovies[1]], totalResults: 2),
          ),
        );
      },
      build: buildBloc,
      act: (bloc) async {
        bloc.add(SearchQuerySubmitted('batman'));
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(SearchNextPageRequested());
      },
      expect: () => [
        isA<SearchLoading>(),
        isA<SearchSuccess>()
            .having((s) => s.movies.length, 'first page count', 1)
            .having((s) => s.hasMore, 'hasMore', true),
        isA<SearchSuccess>().having(
          (s) => s.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        isA<SearchSuccess>()
            .having((s) => s.movies.length, 'total movies', 2)
            .having((s) => s.currentPage, 'currentPage', 2)
            .having((s) => s.hasMore, 'hasMore', false),
      ],
    );
  });
}
