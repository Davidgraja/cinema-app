
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movie_repository_provider.dart';

final nowPlayingMoviesProvider = StateNotifierProvider< MoviesNotifier , List<Movie> >((ref) {

  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;

   return MoviesNotifier(
    fetchMoreMovies:  fetchMoreMovies
   );
});


// Caso de uso , en este caso de uso , indicamos como se va a manejar el listado de peliculas desde este provider 
typedef MovieCallback = Future<List<Movie>> Function({int page});


class MoviesNotifier extends StateNotifier<List<Movie>>{

  int currentPage = 0;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({
    required this.fetchMoreMovies
  }) : super([]);


  Future<void> loadNextPage()  async {
      currentPage++;


      final List<Movie> movies = await fetchMoreMovies(page: currentPage);

      state = [...state , ...movies];
  }

}  
 