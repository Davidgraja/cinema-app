import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

//? Providers
final movieInfoProvider =
    StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {
  final fecthMovie = ref.watch(movieRepositoryProvider).getMovieById;

  return MovieMapNotifier(getMovie: fecthMovie);
});

//?  Case uses
typedef GetMovieCallback = Future<Movie> Function(String movieId);

//? Notifier or controller of the state
class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {
  final GetMovieCallback getMovie;

  MovieMapNotifier({required this.getMovie}) : super({});

  Future<void> loadMovie(String movieId) async {
    if (state[movieId] != null) return;

    await Future.delayed(const Duration(milliseconds: 600));

    final movie = await getMovie(movieId);

    state = {...state, movieId: movie};
  }
}
