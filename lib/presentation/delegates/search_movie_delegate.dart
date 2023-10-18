import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;

  /// ? Implementacion de un Debounce time
  /// Para tener una idea de lo que se trata un Debounce , basicamente se trata de la duración o periodo de tiempo  que
  /// debe de pasar sin que un observable fuente emita  ningun valor y de esta manera despues de determinado tiempo emitir
  /// el valor mas reciente de dicho observable
  /// Esto es necesario cuando existe la posibilidad de que se realicen múltiples llamadas a un método con una corta duración entre si
  /// y es deseabable que solo la última de esas llamadas invoque realmente al método de destino

  // ? implementacion del debounce por medio de un Stream
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();

  //? Un Timer Permite determinar un periodo de tiempo , al igual que limpiarlo y cancelarlo en el caso de se reciban muchos valores
  Timer? _debounceTimer;

  SearchMovieDelegate({required this.searchMovies});

  //? Función encargada que emite el nuevo resultado de las peliculas , se va a llamar cada vez que se añada o elimine una letra al query
  void _onQueryChange(String query) {

    print('Query String cambio');

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel(); //? esta condicion cancela y limpia el Timer cada vez que el query cambie

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      print('buscando peliculas');  //? Esto solo se ejecutara cuando se deja de escribir o que  el query no cambie en  500 milisegundos
    
      // Todo : Bucar peliculas y emitir al Stream
    });
  }

  @override
  String get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        duration: const Duration(milliseconds: 200),
        child: IconButton(
            onPressed: () => query = '', icon: const Icon(Icons.clear_rounded)),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_ios_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //? Esta funcion se va a llamar cada vez que se añada o elimine una letra al query
    _onQueryChange(query);

    //?  uso del stream
    return StreamBuilder(
      stream: debouncedMovies
          .stream, // ? El flujo que este controlador está controlando.
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => _MovieItemSearch(
                  movie: movies[index],
                  onMovieSelected: close,
                ));
      },
    );
  }
}

class _MovieItemSearch extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItemSearch({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            // Image

            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(movie.posterPath)),
            ),

            // Description

            const SizedBox(
              width: 10,
            ),

            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textStyles.titleMedium,
                  ),
                  movie.overview.length > 100
                      ? Text(
                          '${movie.overview.substring(0, 100)}...',
                        )
                      : Text(movie.overview),
                  Row(
                    children: [
                      Icon(
                        Icons.star_half_rounded,
                        color: Colors.yellow.shade800,
                      ),
                      Text(
                        HumanFormats.humanReadbledNumber(movie.voteAverage, 1),
                        style: textStyles.bodyMedium!
                            .copyWith(color: Colors.yellow.shade900),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
