import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;

  SearchMovieDelegate({required this.searchMovies});

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
    return FutureBuilder(
      future: searchMovies(query),
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) =>
                _MovieItemSearch(movie: movies[index]));
      },
    );
  }
}

class _MovieItemSearch extends StatelessWidget {
  final Movie movie;
  const _MovieItemSearch({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
      child:  Row(
        children: [

         // Image

          SizedBox(
            width: size.width * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(movie.posterPath)
            ),
          ),

          // Description

          const SizedBox( width: 10,),

          SizedBox(
            width: size.width * 0.7 ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title , style: textStyles.titleMedium,),

                movie.overview.length > 100 
                ? Text('${movie.overview.substring(0 , 100)}...',)
                : Text(movie.overview),

                Row(
                  children: [
                    Icon(Icons.star_half_rounded , color: Colors.yellow.shade800,),

                    Text(
                      HumanFormats.humanReadbledNumber(movie.voteAverage , 1),

                      style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade900),

                    )
                  ],
                )


              ],
            ),
          )  

        ],
      ),
    );
  }
}
