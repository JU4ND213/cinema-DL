import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../services/tmdb_api.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const MovieCard({required this.movie, required this.onTap, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final poster = movie.posterPath != null
        ? TmdbApi.imageUrl(movie.posterPath!)
        : null;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            poster != null
                ? CachedNetworkImage(
                    imageUrl: poster,
                    placeholder: (_, __) => AspectRatio(
                      aspectRatio: 2 / 3,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, __, ___) => SizedBox(
                      height: 150,
                      child: Center(child: Icon(Icons.broken_image)),
                    ),
                  )
                : SizedBox(
                    height: 150,
                    child: Center(child: Icon(Icons.broken_image)),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (movie.releaseDate ?? '').isNotEmpty
                        ? (movie.releaseDate!.split('-').first)
                        : '',
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14),
                      SizedBox(width: 4),
                      Text(movie.voteAverage.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
