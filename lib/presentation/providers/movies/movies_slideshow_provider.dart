import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

final moviesSlideShowProvider = Provider<List<Movie>>((ref) {
  final movies = ref.watch(nowPlayingMoviesProvider);

  if (movies.isEmpty) return [];

  return movies.sublist(0, 6);
});
