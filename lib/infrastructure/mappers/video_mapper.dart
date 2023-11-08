import 'package:cinemapedia/domian/entities/entities.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_videos.dart';

class VideoMapper {
  static Video moviedbVideoToEntity( Result moviedbVideo ) => Video(
    id: moviedbVideo.id , 
    name: moviedbVideo.name, 
    youtubeKey: moviedbVideo.key, 
    published: moviedbVideo.publishedAt
  );
}