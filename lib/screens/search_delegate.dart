import 'dart:async';
import 'package:flutter/material.dart';
import '../services/tmdb_api.dart';
import '../models/movie.dart';
import '../constants.dart';
import 'detail_screen.dart';

class MovieSearchDelegate extends SearchDelegate<Movie?> {
  Timer? _debounce;
  final api = TmdbApi(apiKey: TMDB_API_KEY);
  List<Movie> results = [];
  bool loading = false;

  get context => null;

  void _onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 400), () async {
      if (q.trim().isEmpty) {
        results = [];
        loading = false;
        showSuggestions(context!);
        return;
      }
      loading = true;
      results = await api.searchMovies(q);
      loading = false;
      showSuggestions(context!);
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    if (loading) return Center(child: CircularProgressIndicator());
    if (results.isEmpty) return Center(child: Text('No hay resultados'));
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, i) {
        final m = results[i];
        return ListTile(
          leading: m.posterPath != null
              ? Image.network(TmdbApi.imageUrl(m.posterPath!))
              : null,
          title: Text(m.title),
          subtitle: Text(
            (m.releaseDate ?? '').isNotEmpty
                ? m.releaseDate!.split('-').first
                : '',
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen(movieId: m.id)),
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );
}
