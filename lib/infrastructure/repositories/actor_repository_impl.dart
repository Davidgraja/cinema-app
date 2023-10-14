import 'package:cinemapedia/domian/datasources/actors_datasources.dart';
import 'package:cinemapedia/domian/entities/actor.dart';
import 'package:cinemapedia/domian/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository {
  final ActorsDatasource datasources;

  ActorRepositoryImpl(this.datasources);

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasources.getActorsByMovie(movieId);
  }
}