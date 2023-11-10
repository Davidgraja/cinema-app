import 'package:cinemapedia/domian/entities/video.dart';
import 'package:flutter/material.dart';

class MovieVideo extends StatelessWidget {
  final Video video;
  final Widget player;
  const MovieVideo({super.key, required this.video, required this.player});

  @override
  Widget build(BuildContext context) {

    final textStyles = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Video' ,style: textStyles.titleLarge,),
          const SizedBox(height: 8,),
  
          Text(video.name),
          const SizedBox(height: 8,),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),  
            child: player
          )
        ],
      ),
    );
  }
}