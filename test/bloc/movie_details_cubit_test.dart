import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_browser/bloc/movie_details/movie_details_cubit.dart';
import 'package:movie_browser/bloc/movie_details/movie_details_state.dart';
import 'package:movie_browser/core/models/movie.dart';
import 'package:movie_browser/core/models/result.dart';
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

  final detailedMovie = Movie(
    title: 'Batman Begins',
    year: '2005',
    imdbID: 'tt0372784',
    type: 'movie',
    poster: 'https://example.com/poster.jpg',
    plot: 'A young Bruce Wayne travels to the Far East...',
    director: 'Christopher Nolan',
    actors: 'Christian Bale, Michael Caine',
    genre: 'Action, Adventure',
    runtime: '140 min',
    rated: 'PG-13',
    imdbRating: '8.2',
  );

  setUpAll(() {
    registerFallbackValue(
      Movie(title: '', year: '', imdbID: '', type: '', poster: ''),
    );
  });

  setUp(() {
    mockHttpService = MockHttpService();
    mockDbService = MockLocalDatabaseService();
    mockLogger = MockLoggerService();
  });

  MovieDetailsCubit buildCubit() => MovieDetailsCubit(
    httpService: mockHttpService,
    dbService: mockDbService,
    logger: mockLogger,
  );

  group('MovieDetailsCubit', () {
    // test the initial state of the cubit
    test('initial state is MovieDetailsInitial', () {
      final cubit = buildCubit();
      expect(cubit.state, isA<MovieDetailsInitial>());
      cubit.close();
    });

    // test the state when the details load successfully
    blocTest<MovieDetailsCubit, MovieDetailsState>(
      'emits [Loading, Loaded] when details load successfully',
      setUp: () {
        when(
          () => mockHttpService.getMovieDetails('tt0372784'),
        ).thenAnswer((_) async => Result.success(detailedMovie));
        when(() => mockDbService.cacheMovie(any())).thenAnswer((_) async {});
      },
      build: buildCubit,
      act: (cubit) => cubit.loadDetails('tt0372784'),
      expect: () => [
        isA<MovieDetailsLoading>(),
        isA<MovieDetailsLoaded>()
            .having((s) => s.movie.title, 'title', 'Batman Begins')
            .having((s) => s.fromCache, 'fromCache', false),
      ],
      verify: (_) {
        verify(() => mockDbService.cacheMovie(any())).called(1);
      },
    );

    // test the state when the details load from cache
    blocTest<MovieDetailsCubit, MovieDetailsState>(
      'falls back to cache when API fails',
      setUp: () {
        when(() => mockHttpService.getMovieDetails('tt0372784')).thenAnswer(
          (_) async => Result.failure('Network error', AppErrorType.network),
        );
        when(
          () => mockDbService.getCachedMovie('tt0372784'),
        ).thenReturn(detailedMovie);
      },
      build: buildCubit,
      act: (cubit) => cubit.loadDetails('tt0372784'),
      expect: () => [
        isA<MovieDetailsLoading>(),
        isA<MovieDetailsLoaded>()
            .having((s) => s.movie.title, 'title', 'Batman Begins')
            .having((s) => s.fromCache, 'fromCache', true),
      ],
    );

    // test the state when the details load from API fails and no cache exists
    blocTest<MovieDetailsCubit, MovieDetailsState>(
      'emits [Loading, Error] when API fails and no cache exists',
      setUp: () {
        when(() => mockHttpService.getMovieDetails('tt0372784')).thenAnswer(
          (_) async => Result.failure('Network error', AppErrorType.network),
        );
        when(() => mockDbService.getCachedMovie('tt0372784')).thenReturn(null);
      },
      build: buildCubit,
      act: (cubit) => cubit.loadDetails('tt0372784'),
      expect: () => [
        isA<MovieDetailsLoading>(),
        isA<MovieDetailsError>().having(
          (s) => s.errorType,
          'errorType',
          AppErrorType.network,
        ),
      ],
    );
  });
}
