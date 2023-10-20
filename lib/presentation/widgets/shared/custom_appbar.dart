import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Icon(
                  Icons.movie_creation_outlined,
                  color: colors.primary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Cinemapedia',
                  style: titleStyle,
                ),

                //?  Con este widget le decimos que tome do el espacio disponible
                const Spacer(),
                IconButton(
                    onPressed: () {
                      final searchMovies = ref.read(searchedMovieProvider);
                      final searchQuery = ref.read(searchQueryProvider);

                      showSearch<Movie?>(
                        query: searchQuery,
                        context: context,
                        delegate: SearchMovieDelegate(
                          initialMovies: searchMovies,
                          clearQuery: ref.read(searchedMovieProvider.notifier).clearSearchedMoviesAndQuery ,
                          searchMovies: ref.read(searchedMovieProvider.notifier).searchMoviesByQuery
                        )
                      )
                      .then((movie) {
                        if (movie == null) return;
                        context.push('/movie/${movie.id}');
                      });
                    },
                    icon: const Icon(Icons.search_outlined))
              ],
            ),
          ),
        ));
  }
}
