
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_repository_provider.dart';

final nowPlayingMoviesProvider = StateNotifierProvider< MoviesNotifier , List<Movie> >((ref) {

  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

   return MoviesNotifier(
    fetchMoreMovies:  fetchMoreMovies
   );
});


final popularMoviesProvider = StateNotifierProvider< MoviesNotifier , List<Movie> >((ref) {

  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;

   return MoviesNotifier(
    fetchMoreMovies:  fetchMoreMovies
   );
});


final topRatedMoviesProvider = StateNotifierProvider< MoviesNotifier , List<Movie> >((ref) {

  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;

   return MoviesNotifier(
    fetchMoreMovies:  fetchMoreMovies
   );
});


final upcomingMoviesProvider = StateNotifierProvider< MoviesNotifier , List<Movie> >((ref) {

  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpcoming;

   return MoviesNotifier(
    fetchMoreMovies:  fetchMoreMovies
   );
});



// Caso de uso , en este caso de uso , indicamos como se va a manejar el listado de peliculas desde este provider 
typedef MovieCallback = Future<List<Movie>> Function({int page});


class MoviesNotifier extends StateNotifier<List<Movie>>{

  int currentPage = 0;
  MovieCallback fetchMoreMovies;
  bool isLoading = false;

  MoviesNotifier({
    required this.fetchMoreMovies
  }) : super([]);


  Future<void> loadNextPage()  async {
      if(isLoading) return;

      isLoading = true;
      currentPage++;

      final List<Movie> movies = await fetchMoreMovies(page: currentPage);
      await Future.delayed(const Duration(microseconds: 300));
      
      state = [...state , ...movies];
      isLoading = false;
  }

}  
 