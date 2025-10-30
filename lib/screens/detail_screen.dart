import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tmdb_api.dart';
import '../models/movie.dart';
import '../constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/favorites_provider.dart';

class DetailScreen extends StatefulWidget {
  final int movieId;
  const DetailScreen({required this.movieId, super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Movie? movie;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = TmdbApi(apiKey: TMDB_API_KEY);
    final m = await api.fetchMovieDetails(widget.movieId);
    setState(() {
      movie = m;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favProv = Provider.of<FavoritesProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: loading || movie == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (movie!.backdropPath != null)
                    CachedNetworkImage(
                      imageUrl: TmdbApi.imageUrl(movie!.backdropPath!),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            movie!.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            favProv.isFavorite(movie!.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          onPressed: () => favProv.toggleFavorite(movie!),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Año: ${movie!.releaseDate != null ? movie!.releaseDate!.split('-').first : 'N/A'}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(movie!.overview),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.star),
                        SizedBox(width: 4),
                        Text(movie!.voteAverage.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
