import 'package:cinemapedia/domian/entities/entities.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final similarMoviesProvider = FutureProvider.family((ref , int movieId){
  final movieRepository = ref.watch(movieRepositoryProvider);

  return movieRepository.getSimilarMovies(movieId);

});


class SimilarMovies extends ConsumerWidget {
  final int movieId;
  const SimilarMovies({ required this.movieId , super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    
 
    final similarMoviesFuture = ref.watch(similarMoviesProvider( movieId));

    return similarMoviesFuture .when(
      data: (data) => _RecommendedMovies(movies: data) , 
      error: (_, __) => const Center(child: Text('No se ah logrado cargar las peliculas similares'),) , 
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2,),),
    );
  }
}


class _RecommendedMovies extends StatelessWidget {

  final List<Movie> movies;
  const _RecommendedMovies({required this.movies});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child:MovieHorizontalListView(movies: movies , title: 'Recomendaciones') ,
    );
  }
}