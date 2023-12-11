import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/domian/entities/video.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

final FutureProviderFamily<List<Video> , int> videosFromMovieProvider = FutureProvider.family((ref , int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);

  return movieRepository.getYoutubeVideosById(movieId);
});


class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie_screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieScreen>{
  @override
  void initState() {
    super.initState();

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context)  {

    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];
    
    if (movie == null) {
      return _LoadingInfo();
    }

    final videosFromMovie =  ref.watch(videosFromMovieProvider(movie.id));

    return videosFromMovie.when(
      data: (data) => Videobuilder(videos: data , movie: movie) , 
      error: (_ , __) =>  const SizedBox(), 
      loading: () => _LoadingInfo()
    );

  }
  
}

class _LoadingInfo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}


class Videobuilder extends StatefulWidget {
  final Movie movie;
  final List<Video> videos; 
  const Videobuilder({super.key, required this.videos, required this.movie});

  @override
  State<Videobuilder> createState() => _VideobuilderState();
}

class _VideobuilderState extends State<Videobuilder> {


  late YoutubePlayerController controller;

  late String youtubeKey;
  late bool isEmpty;

  @override
  void initState() {

    if(widget.videos.isNotEmpty){
      youtubeKey = widget.videos.first.youtubeKey;
      isEmpty = false;
    }
    else{
      youtubeKey = '';
      isEmpty = true;
    }
    
    controller = YoutubePlayerController(
      initialVideoId: youtubeKey,
      flags: const  YoutubePlayerFlags(
        autoPlay: false,
        hideThumbnail: true,
        showLiveFullscreenButton: false,
        disableDragSeek: true,
        enableCaption: false
      )
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Videobuilder oldWidget) {
    controller.pause();
    super.didUpdateWidget(oldWidget);
  }


  @override
  Widget build(BuildContext context) {
    return  YoutubePlayerBuilder(
      player: YoutubePlayer(controller: controller), 
      builder: (context, player) {

        return  Scaffold(
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            _CustomSliverAppBar(
              movie: widget.movie,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (context, index) => _MovieDetails(
                      movie: widget.movie , 
                      player:  isEmpty ? const SizedBox() : MovieVideo(video: widget.videos.first, player: player) 
                  )
              )
            ),
          ],),
        );
      },
    );
  }
}


class _MovieDetails extends StatelessWidget {
  final Movie movie;
  final Widget player;

  const _MovieDetails({required this.movie, required this.player});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MovieInfo(movie: movie, size: size, textStyles: textStyles),

        _GeneresChips(movie: movie),

        _ActorsByMovie(movieId: movie.id.toString()),
 
        player,

        SimilarMovies(movieId: movie.id, ),

        // const SizedBox( height: 20,),

      ],
    );
  }
}

class _MovieInfo extends StatelessWidget {
  const _MovieInfo({
    required this.movie,
    required this.size,
    required this.textStyles,
  });

  final Movie movie;
  final Size size;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

class _GeneresChips extends StatelessWidget {
  const _GeneresChips({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2),),
      ) ;
    }

    final actors = actorsByMovie[movieId];

    return SizedBox(
      height: 250.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors!.length,
          itemBuilder: (context, index) {
            final actor = actors[index];

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    actor.character ?? '',
                    maxLines: 1,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis
                      ),
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