import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod_player/pod_player.dart';
import 'package:cinemapedia/domian/entities/entities.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

// Provider  of video by movie 
final FutureProviderFamily<List<Video> , int> videosFromMovieProvider = FutureProvider.family((ref , int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);

  return movieRepository.getYoutubeVideosById(movieId);
});

class MovieVideo extends ConsumerWidget {
  final int movieId;
  const MovieVideo({super.key , required this.movieId});

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
  late final PodPlayerController controller;
  late String youtubeLink;
  bool isEmpty = false;
 
  @override
  void initState() {

    if(widget.videos.isEmpty) {
      youtubeLink = 'https://youtu.be/A3ltMaM6noM';
      isEmpty = true;
      
    }else {
      youtubeLink = 'https://youtu.be/${widget.videos.first.youtubeKey}';
    }

    controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.youtube(youtubeLink),
        podPlayerConfig: const PodPlayerConfig(
        autoPlay: false,
        isLooping: false,
      )
    )..initialise();  

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(isEmpty){
      return const Center(
        child: Text('El trailer no ha sido añadido '),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.videos.first.name , style: Theme.of(context).textTheme.labelLarge,),
    
        const SizedBox(height: 10,),
    
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: PodVideoPlayer(controller: controller)
        ),
      ],
    );
  }
}