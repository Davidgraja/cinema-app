import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domian/entities/entities.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


// Provider  of video by movie 
final FutureProviderFamily<List<Video> , int> videosFromMovieProvider = FutureProvider.family((ref , int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);

  return movieRepository.getYoutubeVideosById(movieId);
});


class MovieVideoTest extends ConsumerWidget {
  final int movieId;
  const MovieVideoTest({super.key , required this.movieId});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final videosFromMovie =  ref.watch(videosFromMovieProvider(movieId));

    return videosFromMovie.when(
      data: (videos) => _MovieVideoView(videos: videos),
      error: (error, stackTrace) =>  SizedBox(child: Text(error.toString()),),
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2,),),
    );
  }
}


class _MovieVideoView extends StatefulWidget {
  final List<Video> videos;
  const _MovieVideoView({required this.videos});

  @override
  State<_MovieVideoView> createState() => _MovieVideoViewState();
}

class _MovieVideoViewState extends State<_MovieVideoView> {

  late YoutubePlayerController controller;
  late String youtubeKey;
 

  @override
  void initState() {

    if(widget.videos.isEmpty) {
      youtubeKey = '';
    }else {
      youtubeKey = widget.videos.first.youtubeKey;
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
  Widget build(BuildContext context) {

    if(youtubeKey.isEmpty){
      return const Center(
        child: Text('El trailer no ha sido añadido '),
      );
    }

  
    return Column(
      children: [
        Text(widget.videos.first.name),
    
        const SizedBox(height: 10,),
    
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: YoutubePlayer(
            controller: controller,
          ),
        ),
      ],
    );
  }
}