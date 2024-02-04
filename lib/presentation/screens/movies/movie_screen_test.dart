import 'package:cinemapedia/domian/entities/entities.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MovieScreenTest extends ConsumerStatefulWidget {
  final String movieId;
  const MovieScreenTest({super.key , required this.movieId});

  @override
  MovieScreenTestState  createState() => MovieScreenTestState();
}

class MovieScreenTestState extends ConsumerState<MovieScreenTest> {

  @override
  void initState() {

    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorsByMovieProvider.notifier).loadActors(widget.movieId);
    
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if(movie == null){
      return const Scaffold(body: FullScreenLoader());
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
           onPressed: () => context.pop() ,
        ),
      ),
      body:  SingleChildScrollView(child: _MovieInfo(movie: movie,)),
    );
  }
}


class _MovieInfo extends StatelessWidget {
  final Movie movie;
  const _MovieInfo({required this.movie});

  @override
  Widget build(BuildContext context) { 

    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
      
        crossAxisAlignment: CrossAxisAlignment.center,
      
        children: [
      
        // image
      
        _MovieImage(urlImage: movie.posterPath,),
      
      
        // name and save
      
        const SizedBox(height: 20,),
      
        _Header(movieName: movie.title,),
      
      
        // more information
      
        const SizedBox(height: 20,),
      
      _InformationSubtitles( movie: movie,),
      
      
        // tabbar
        const SizedBox(height: 20,),
      
        _CustomTabBar(movie: movie,) 
      
      
        ],
      ),
    );
  }
}

class _MovieImage extends StatelessWidget {
  final String urlImage;
  const _MovieImage({required this.urlImage});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 500
        ),
        child: Image.network(
          urlImage,
          fit: BoxFit.contain,
        ),
      )
    );
  }
}

class _Header extends StatelessWidget {
  final String movieName;
  const _Header({required this.movieName});


  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 250,
          child: Text(
            movieName ,
            style: const TextStyle(fontSize: 18),
            overflow: TextOverflow.ellipsis ,
            maxLines: 2
          )
        ),
    
        //TODO : implementar guardado de pelicula
    
        GestureDetector(
          onTap: () => print('hola'),
          child: Icon(Icons.bookmark_outline_rounded ,  color: theme.colorScheme.primary)
        )
      ],
    );
  }
}

class _InformationSubtitles extends StatelessWidget {
  final Movie movie;
  const _InformationSubtitles({required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        _CustomSizeBox(
          textValue: movie.originalLanguage, 
          icon: Icon(Icons.language_rounded , color: theme.colorScheme.primary, size: 20,)
        ),
        
        _CustomSizeBox(
          textValue: " ${movie.releaseDate.day}-${movie.releaseDate.month}-${movie.releaseDate.year}  ", 
          icon: Icon(Icons.date_range_outlined , color: theme.colorScheme.primary, size: 20,)
        ),
        
        
        _CustomSizeBox(
          textValue: movie.voteAverage.toString(), 
          icon: Icon(Icons.star_half_outlined , color: Colors.yellow.shade800, size: 20,)
        )
        
      ],
    );
  }
}

class _CustomTabBar extends StatelessWidget {
  final Movie movie;
  const _CustomTabBar({required this.movie});


  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
             decoration: BoxDecoration(
              border: Border.all(width: 1.0 ,color: theme.colorScheme.secondary),
              borderRadius: BorderRadius.circular(18)
             ), 
      
            child: TabBar(
              dividerHeight: 0,
              splashBorderRadius: BorderRadius.circular(18),
              indicatorPadding: const EdgeInsets.all(10),
              tabs: const [
                
                Tab(
                  text: 'Detalles',
                ),
            
                Tab(
                  text: 'Trailers',
                ),
            
                Tab(
                  text: 'Actores',
                ),
              ], 
            ),
          ),
      
      
          Container(
            constraints: const BoxConstraints(
              maxHeight: 380
            ),
            margin: const EdgeInsets.only(top: 20),
            child: TabBarView(
              clipBehavior: Clip.antiAlias,
              children: [
                _TabBarViewDetails(geners: movie.genreIds, overview: movie.overview),
            
                const Text('Trailers'),
                
                const Text('Actores'),
              ]
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomSizeBox extends StatelessWidget {
  final String textValue;
  final Icon icon;
  const _CustomSizeBox({ required this.textValue ,required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Text( textValue),
          const SizedBox( width: 8,),
          icon
        ]
      ),
    );
  }
}

class _TabBarViewDetails extends StatelessWidget {
  
  final List<String> geners;
  final String overview;
  const _TabBarViewDetails({required this.geners , required this.overview});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children: [
            Text('Genero: ' , style: theme.textTheme.labelLarge,),
    
            ...geners.map((e) => Chip(
              label: Text(e) ,
              padding: const EdgeInsets.all(1.0),
              shape: RoundedRectangleBorder(side: BorderSide(color: theme.colorScheme.primary  ) ,borderRadius: BorderRadius.circular(8.0)),
            )).toList(),     
    
          ],
        ),

        const SizedBox(height: 10,),
    
        Wrap(
          children: [

            Text('Descripción : ' , style: theme.textTheme.labelLarge,),

            Text(overview , overflow: TextOverflow.ellipsis, maxLines: 14,)

          ],
        )
      
      ],
    );
  }
}