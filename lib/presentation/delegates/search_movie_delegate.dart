import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);


class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  VoidCallback clearQuery;

  /// ? Implementacion de un Debounce time
  /// Para tener una idea de lo que se trata un Debounce , basicamente se trata de la duración o periodo de tiempo  que
  /// debe de pasar sin que un observable fuente emita  ningun valor y de esta manera despues de determinado tiempo emitir
  /// el valor mas reciente de dicho observable
  /// Esto es necesario cuando existe la posibilidad de que se realicen múltiples llamadas a un método con una corta duración entre si
  /// y es deseabable que solo la última de esas llamadas invoque realmente al método de destino

  // ? implementacion del debounce por medio de un Stream
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  //? Un Timer Permite determinar un periodo de tiempo , al igual que limpiarlo y cancelarlo en el caso de se reciban muchos valores
  Timer? _debounceTimer;

  SearchMovieDelegate({required this.searchMovies , required this.clearQuery , required this.initialMovies}) : super(searchFieldLabel: 'Buscar películas');

  void clearStreams(){
    isLoadingStream.close();
    debouncedMovies.close();
  }

  //? Función encargada que emite el nuevo resultado de las peliculas , se va a llamar cada vez que se añada o elimine una letra al query
  void _onQueryChange(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel(); //? esta condicion cancela y limpia el Timer cada vez que el query cambie

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      //? El codigo solo se ejecutara cuando se deja de escribir o que  el query no cambie en  500 milisegundos
      final movies = await searchMovies(query);
      initialMovies = movies;

      if(!debouncedMovies.isClosed) {
        debouncedMovies.add(movies);
        isLoadingStream.add(false);
      };
    });
  }

  Widget buildResultAndSuggestions(){
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) => _MovieItemSearch(
              movie: movies[index],
              onMovieSelected:( context, movie){
                clearStreams();
                close(context , movie);
              } ,
            ));
      },
    );
  }


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
          stream: isLoadingStream.stream ,
          builder: (context, snapshot) {

            if(snapshot.data ?? false){
              return SpinPerfect(
                duration: const Duration(seconds: 20),
                spins: 10 ,
                infinite: true,
                child: IconButton(
                    onPressed: (){
                      query = '';
                      debouncedMovies.add([]);
                      clearQuery();
                    },
                    icon: const Icon(Icons.refresh_rounded)),
              );
            }

            return FadeIn(
              animate: query.isNotEmpty,
              duration: const Duration(milliseconds: 200),
              child: IconButton(
                  onPressed: (){
                    query = '';
                    debouncedMovies.add([]);
                    clearQuery();
                  },
                  icon: const Icon(Icons.clear_rounded)),
            );
          },
      )

    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          clearStreams();
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios_rounded));
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //? Esta funcion se va a llamar cada vez que se añada o elimine una letra al query
    _onQueryChange(query);

    //?  uso del stream
    return buildResultAndSuggestions();
  }
}

typedef MovieSelected = void Function(BuildContext context , Movie movie);
class _MovieItemSearch extends StatelessWidget {
  final Movie movie;
  final MovieSelected onMovieSelected;

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
                  child: FadeInImage(
                    placeholderFit: BoxFit.cover,
                    fit: BoxFit.cover,
                    placeholder: const AssetImage('assets/images/fade-loading.gif') ,
                    image: NetworkImage(movie.posterPath),
                  )
              ),
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
