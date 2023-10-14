import 'package:cinemapedia/domian/entities/actor.dart';

abstract class ActorsDatasource {
  Future<List<Actor>> getActorsByMovie( String movieId );
}
