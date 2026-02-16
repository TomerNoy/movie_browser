import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_browser/core/models/movie.dart';
import 'package:movie_browser/core/models/result.dart';

class HttpService {
  final Dio dio;

  HttpService({required this.dio});

  Future<Result<List<Movie>>> queryMovies(String query) async {
    try {
      final apiKey = dotenv.env['OMDb_API_KEY'];
      final response = await dio.get(
        'https://www.omdbapi.com/',
        queryParameters: {'apikey': apiKey, 's': query},
      );

      final data = response.data;

      if (data['Response'] == 'False') {
        return Result.failure(data['Error'] ?? 'No results found');
      }

      final movies = (data['Search'] as List)
          .map((json) => Movie.fromJson(json))
          .toList();

      return Result.success(movies);
    } on DioException catch (e) {
      return Result.failure(e.message ?? 'Network error');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
