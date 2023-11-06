import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends  ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {

  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    loadNextPage();
  }


  void loadNextPage() async {
    if(isLoading || isLastPage) return;
    isLoading = true;
    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;

    if(movies.isEmpty){
      isLastPage = true;
    }

  }

  @override
  Widget build(BuildContext context) {

    final List<Movie> favoritesMovies =  ref.watch(favoriteMoviesProvider).values.toList();

    if(favoritesMovies.isEmpty){
      final colorScheme = Theme.of(context).colorScheme;
      return SizedBox.expand(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_outlined , size: 60  , color: colorScheme.inversePrimary,),
              const Text('Ohh nooo!' , style:  TextStyle(fontSize: 30),),
              const Text('Aun no tiene películas favoritas' , style:  TextStyle(fontSize: 20),),

              const SizedBox(height: 10,),

              FilledButton.tonal(onPressed: () => context.go('/home/0'), child: const Text('Empieza a buscar'))
            ],
          )
      );
    }

    return Scaffold(
      body: MovieMasonry(movies: favoritesMovies, loadNextPage: loadNextPage,)
    );
  }
}