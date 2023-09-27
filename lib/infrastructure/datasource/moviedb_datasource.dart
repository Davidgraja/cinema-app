
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domian/datasources/movies_datasources.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia/domian/entities/movie.dart';


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

    final response = dio.get('/movie/now_playing');

    final List<Movie> movies = [];
    
    return movies;
  }

}