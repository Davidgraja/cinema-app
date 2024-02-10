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

class FavoritesViewState extends ConsumerState<FavoritesView> with AutomaticKeepAliveClientMixin{

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
    super.build(context);

    final List<Movie> favoritesMovies =  ref.watch(favoriteMoviesProvider).values.toList();

    if(favoritesMovies.isEmpty){
      final colorScheme = Theme.of(context).colorScheme;
      return SizedBox.expand(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ohh nooo!' , style:  TextStyle(fontSize: 30),),
              const Text('No tiene películas guardadas ' , style:  TextStyle(fontSize: 20),),

              const SizedBox(height: 10,),

              FilledButton.tonal(onPressed: () => context.go('/home/0'), child: const Text('Empezar a buscar'))
            ],
          )
      );
    }

    return Scaffold(
      body: MovieMasonry(movies: favoritesMovies, loadNextPage: loadNextPage,)
    );
  }
  
  @override
  
  bool get wantKeepAlive => true;
}