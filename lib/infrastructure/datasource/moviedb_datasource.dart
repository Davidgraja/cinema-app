import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';

import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/domian/datasources/movies_datasources.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';


class MoviesdbDatasources extends MoviesDataSources{

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {
      'api_key' : Environment.theMovieDbKey,
      'language' : 'es-ES'
    }
  ));

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {

    final response = await dio.get('/movie/now_playing');

    final movieDbData = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies = movieDbData.results
    .where((movie) => movie.posterPath != 'no-poster')
    .map((movie) => MovieMapper.movieDBToEntity(movie)).toList();
    
    return movies;
  }

}