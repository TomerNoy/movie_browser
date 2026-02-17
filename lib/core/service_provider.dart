import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:movie_browser/bloc/movie_details/movie_details_cubit.dart';
import 'package:movie_browser/bloc/search/search_bloc.dart';
import 'package:movie_browser/core/locale_notifier.dart';
import 'package:movie_browser/services/http_service.dart';
import 'package:movie_browser/services/local_database_service.dart';
import 'package:movie_browser/services/logger_service.dart';

final getIt = GetIt.instance;

void setupServiceProvider() {
  getIt.registerLazySingleton<LocaleNotifier>(() => LocaleNotifier());

  getIt.registerLazySingleton<LoggerService>(() => LoggerService());

  getIt.registerLazySingleton<HttpService>(() => HttpService(dio: Dio()));

  getIt.registerLazySingleton<LocalDatabaseService>(
    () => LocalDatabaseService(hive: Hive),
  );

  getIt.registerFactory<SearchBloc>(
    () => SearchBloc(
      httpService: httpService,
      dbService: localDatabaseService,
      logger: logger,
    ),
  );

  getIt.registerFactory<MovieDetailsCubit>(
    () => MovieDetailsCubit(
      httpService: httpService,
      dbService: localDatabaseService,
      logger: logger,
    ),
  );
}

LocaleNotifier get localeNotifier => getIt<LocaleNotifier>();
HttpService get httpService => getIt<HttpService>();
LocalDatabaseService get localDatabaseService => getIt<LocalDatabaseService>();
LoggerService get logger => getIt<LoggerService>();
