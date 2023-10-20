import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

final searchQueryProvider = StateProvider((ref) => '');

final searchedMovieProvider = StateNotifierProvider<SearchedMoviesNotifier  , List<Movie>>((ref) {
  final movieRepository = ref.read(movieRepositoryProvider);

  return SearchedMoviesNotifier(searchMovies: movieRepository.searchMovies, ref: ref);
});


typedef SearchMoviesMoviesCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>>{

  final SearchMoviesMoviesCallback searchMovies;
  final Ref ref;
  SearchedMoviesNotifier({required this.searchMovies , required this.ref}): super([]);

  Future<List<Movie>> searchMoviesByQuery( String query) async {
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = movies;
    return movies;
  }

  void clearSearchedMoviesAndQuery (){
    ref.read(searchQueryProvider.notifier).update((state) => '');
    state = [];
  }
}