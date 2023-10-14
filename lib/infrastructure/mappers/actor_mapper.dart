import 'package:cinemapedia/domian/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_responses.dart';

class ActorMapper {
  static Actor castToEntity(Cast castInfo) =>
      Actor(
        id: castInfo.id, 
        name: castInfo.name, 
        profilePath: (castInfo.profilePath != null)
          ? 'https://image.tmdb.org/t/p/w500/${castInfo.profilePath}'
          : 'https://www.htgtrading.co.uk/wp-content/uploads/2016/03/no-user-image-square.jpg' , 
        character: castInfo.character
      );
}
