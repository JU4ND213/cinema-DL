import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_api.dart';

class MovieProvider extends ChangeNotifier {
  final TmdbApi api;
  List<Movie> movies = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;

  MovieProvider({required this.api});

  Future<void> loadInitial() async {
    page = 1;
    movies = [];
    hasMore = true;
    await loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    notifyListeners();
    try {
      final fetched = await api.fetchPopular(page: page);
      if (fetched.isEmpty) {
        hasMore = false;
      } else {
        movies.addAll(fetched);
        page++;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Movie>> search(String q, {int page = 1}) =>
      api.searchMovies(q, page: page);
}
