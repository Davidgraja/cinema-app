
import 'package:cinemapedia/domian/entities/actor.dart';

abstract class ActorsRepository {
  Future<List<Actor>> getActorsByMovie( String movieId );
}
