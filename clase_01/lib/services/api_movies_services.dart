import 'package:clase_01/models/api_movies_model.dart';
import 'package:dio/dio.dart';

class ApiMoviesServices {
  final dio = Dio();

  final URL =
      "https://api.themoviedb.org/3/movie/popular?api_key=8717dcf18ccc3528027d19536569273d&language=es-MX&page=1";

  Future<List<ApiMoviesModel>> getMovies() async {
    final response = await dio.get(URL);
    final movies = response.data['results'] as List;

    return movies.map((movie) => ApiMoviesModel.fromMap(movie)).toList();
  }
}
