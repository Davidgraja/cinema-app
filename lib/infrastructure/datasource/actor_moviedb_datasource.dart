import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domian/entities/actor.dart';
import 'package:cinemapedia/domian/datasources/actors_datasources.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_responses.dart';

class ActorMoviedbDatasource extends ActorsDatasource {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Environment.theMovieDbKey, 'language': 'es-ES'}));

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    final credistReponse = CreditsResponses.fromJson(response.data);

    final List<Actor> actors =  credistReponse.cast.map((cast) => ActorMapper.castToEntity(cast)).toList();

    return actors;
  }
}
