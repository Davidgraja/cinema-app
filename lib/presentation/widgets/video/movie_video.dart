import 'package:cinemapedia/domian/entities/video.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


final FutureProviderFamily<List<Video> , int> videosFromMovieProvider = FutureProvider.family((ref , int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);

  return movieRepository.getYoutubeVideosById(movieId);
});

class VideosFromMovie extends ConsumerWidget {
  final int movieId;
  
  const VideosFromMovie({super.key, required this.movieId});

  @override
  Widget build(BuildContext context , WidgetRef ref) {

    final videosFromMovie = ref.watch(videosFromMovieProvider(movieId));

    return videosFromMovie.when(
      data: (data) => _VideoPlayer(video: data), 
      error: (_ , __) =>  const Center(child: Text('No se a podido cargar el video')), 
      loading: () => const CircularProgressIndicator(strokeWidth: 2,)
    );
  }
}


class _VideoPlayer extends StatelessWidget {
  
  final List<Video> video;

  const _VideoPlayer({required this.video});

  @override
  Widget build(BuildContext context) {
    
    final textStyles = Theme.of(context).textTheme;

    if(video.isEmpty){
      return const SizedBox();
    }


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0 , horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Video' , style: textStyles.titleLarge,),
        
          const SizedBox(height: 8.0,),
         
          _YoutubeVideoPlayer( video: video.first,)
        ]
      ),
    );
  }
}

class _YoutubeVideoPlayer extends StatefulWidget {
  final Video video;
  const _YoutubeVideoPlayer({ required this.video});


  @override
  State<_YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<_YoutubeVideoPlayer> {
  
  late YoutubePlayerController controller;

  @override
  void initState() {
    
    controller = YoutubePlayerController(
      initialVideoId:  widget.video.youtubeKey,
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
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Text(widget.video.name),
        
        const SizedBox(height: 8.0,),

        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: YoutubePlayer(controller: controller)
        ),
      ],
    );
  }
}