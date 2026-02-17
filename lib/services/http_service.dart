import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_browser/core/models/movie.dart';
import 'package:movie_browser/core/models/result.dart';
import 'package:movie_browser/core/models/search_response.dart';

class HttpService {
  final Dio dio;

  static const String omdbApiUrl = 'https://www.omdbapi.com/';

  HttpService({required this.dio});

  Future<Result<SearchResponse>> queryMovies(
    String query, {
    int page = 1,
  }) async {
    try {
      final apiKey = dotenv.env['OMDb_API_KEY'];
      final response = await dio.get(
        omdbApiUrl,
        queryParameters: {'apikey': apiKey, 's': query, 'page': page},
      );

      final data = response.data;

      if (data['Response'] == 'False') {
        final error = data['Error'] ?? '';
        if (error.contains('Too many results')) {
          return Result.failure(error, AppErrorType.tooManyResults);
        }
        if (error.contains('not found')) {
          return Result.failure(error, AppErrorType.noResults);
        }
        return Result.failure(error, AppErrorType.api);
      }

      final movies = (data['Search'] as List)
          .map((json) => Movie.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      final totalResults =
          int.tryParse(data['totalResults']?.toString() ?? '0') ?? 0;

      return Result.success(
        SearchResponse(movies: movies, totalResults: totalResults),
      );
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Network error', AppErrorType.network);
    } catch (e) {
      return Result.failure(e.toString(), AppErrorType.unknown);
    }
  }

  Future<Result<Movie>> getMovieDetails(String imdbID) async {
    try {
      final apiKey = dotenv.env['OMDb_API_KEY'];
      final response = await dio.get(
        omdbApiUrl,
        queryParameters: {'apikey': apiKey, 'i': imdbID, 'plot': 'full'},
      );

      final data = response.data;

      if (data['Response'] == 'False') {
        return Result.failure(data['Error'] ?? 'Not found', AppErrorType.api);
      }

      return Result.success(Movie.fromJson(Map<String, dynamic>.from(data)));
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Network error', AppErrorType.network);
    } catch (e) {
      return Result.failure(e.toString(), AppErrorType.unknown);
    }
  }
}
