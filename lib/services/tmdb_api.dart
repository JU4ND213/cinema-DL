import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/movie.dart';

class TmdbApi {
  final String apiKey;

  TmdbApi({required this.apiKey});

  Future<List<Movie>> fetchPopular({int page = 1}) async {
    final uri = Uri.parse(
      "$TMDB_BASE/movie/popular?api_key=$apiKey&page=$page",
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List results = data['results'];
      return results.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final uri = Uri.parse(
      "$TMDB_BASE/search/movie?api_key=$apiKey&query=${Uri.encodeQueryComponent(query)}&page=$page",
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final List results = data['results'];
      return results.map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Future<Movie> fetchMovieDetails(int movieId) async {
    final uri = Uri.parse(
      "$TMDB_BASE/movie/$movieId?api_key=$apiKey&append_to_response=credits",
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  static String imageUrl(String path) => "$IMAGE_BASE$IMAGE_SIZE$path";
}
