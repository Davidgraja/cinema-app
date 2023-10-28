import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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


    return Scaffold(
      // TODO : Ver como solucionar de una mejor manera el problema del scroll
      body: Container(color: Colors.transparent, height: MediaQuery.of(context).size.height - 100,child: MovieMasonry(movies: favoritesMovies, loadNextPage: loadNextPage,))
    );
  }
}