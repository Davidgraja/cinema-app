import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie_screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(
            movie: movie,
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => _MovieDetails(movie: movie),
                  childCount: 1)),
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //? Imagen
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    movie.posterPath,
                    fit: BoxFit.cover,
                    width: size.width * 0.3,
                  )),

              const SizedBox(
                width: 10,
              ),

              //? Descripción
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: textStyles.titleLarge,
                      ),
                      Text(
                        movie.overview,
                        style: textStyles.labelLarge,
                      )
                    ]),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            children: [
              ...movie.genreIds.map((gender) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Chip(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      label: Text(gender),
                    ),
                  ))
            ],
          ),
        ),
        _ActorsByMovie(movieId: movie.id.toString()),
        const SizedBox(
          height: 40,
        )
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorsByMovie = ref.watch(actorsByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(strokeWidth: 2);
    }

    final actors = actorsByMovie[movieId];

    return SizedBox(
      height: 300.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors!.length,
          itemBuilder: (context, index) {
            final actor = actors[index];

            return Container(
              padding: const EdgeInsets.all(8.0),
              width: 135,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  //? actor photo 

                  FadeIn(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        actor.profilePath,
                        width: 135,
                        height: 180,
                        fit: BoxFit.cover,
                        
                      ),
                    ),
                  ),

                  //? actor name 

                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    actor.name,
                    maxLines: 2,
                  ),
                  Text(
                    actor.character ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

// provider para identificar si una movie esta dento de favoritos
final isFavoriteProvider = FutureProvider.family.autoDispose((ref , int movieId ){

  final localStorageRepository = ref.watch(LocalStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;
  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
      
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));
    
    final size = MediaQuery.of(context).size;

    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return SliverAppBar(
      backgroundColor: Colors.black,
      shape: Border(
        bottom: BorderSide(
          color: scaffoldBackgroundColor
        )
      ) ,
      expandedHeight: size.height * 0.7,
      leading: IconButton( 
        onPressed: () => context.pop() , 
        icon: const Icon(Icons.arrow_back_ios , color: Colors.white,) ) ,
      actions: [
        IconButton(
          onPressed: () async {
            await ref.read(favoriteMoviesProvider.notifier).toggleFavorite(movie);
            ref.invalidate(isFavoriteProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
            loading: () => const CircularProgressIndicator(strokeWidth: 2,),
            data: (isFavorite) =>  isFavorite
            ? const Icon(Icons.favorite_rounded , color: Colors.red,)
            : const Icon(Icons.favorite , color: Colors.white,),
            error: (_, __) => throw  UnimplementedError(),
          )
        )
      ],     
      flexibleSpace: FlexibleSpaceBar( 
        titlePadding: const EdgeInsets.all(0),        
        title: _CustomGradient(
          begin: Alignment.topCenter ,
          end:  Alignment.bottomCenter,
          stops: const [0.9 , 1.0],
          colors: [Colors.transparent , scaffoldBackgroundColor],
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) return const SizedBox();

                  return FadeIn(child: child);
                },
              ),
            ),

            const _CustomGradient(
              begin: Alignment.topCenter, 
              end: Alignment.bottomCenter, 
              stops: [0.7 , 1.0], 
              colors: [Colors.transparent , Colors.black26]
            ),


            const _CustomGradient(
              begin: Alignment.topRight, 
              end: Alignment.bottomLeft, 
              stops: [0.0 , 0.2], 
              colors: [Colors.black26 ,Colors.transparent ]
            ),
          

              const _CustomGradient(
              begin: Alignment.topLeft, 
              end: Alignment.bottomRight, 
              stops: [0.0 , 0.2], 
              colors: [Colors.black26 ,Colors.transparent ]
            ),
          ],
        ),
      ),
    );
  }
}


class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;  
  final List<Color> colors;  
  const _CustomGradient({
    this.begin = Alignment.centerLeft, 
    this.end = Alignment.centerRight, 
    required this.stops, 
    required this.colors
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
          begin: begin,
          end: end,
          stops: stops  , 
          colors: colors 
        )),
      ),
    );
  }
}