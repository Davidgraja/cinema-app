import 'package:cinemapedia/domian/entities/video.dart';
import 'package:cinemapedia/infrastructure/mappers/video_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_videos.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia/config/constants/environment.dart';

import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/domian/datasources/movies_datasources.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';

class MoviesdbDatasources extends MoviesDataSources {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Environment.theMovieDbKey,
        'language': 'es-ES'
      }));

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDbData = MovieDbResponse.fromJson(json);

    final List<Movie> movies = movieDbData.results
        .map((movie) => MovieMapper.movieDBToEntity(movie))
        .where((movie) => movie.posterPath != 'no-poster')
        .toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response =
        await dio.get('/movie/now_playing', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response =
        await dio.get('/movie/popular', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response =
        await dio.get('/movie/top_rated', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response =
        await dio.get('/movie/upcoming', queryParameters: {'page': page});

    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');

    if (response.statusCode != 200) {
      throw Exception('Movie with id: $id no found');
    }

    final movieDetails = MovieDetails.fromJson(response.data);

    final Movie movie = MovieMapper.movieDetailsEntity(movieDetails);

    await Future.delayed(const Duration(milliseconds: 600));

    return movie;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {

    if(query.isEmpty) return [];

    final response =
        await dio.get('/search/movie', queryParameters: {'query': query});

    if (response.statusCode != 200) {
      throw Exception('Movie  $query no found');
    }

    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int id) async {
    final response = await dio.get('/movie/$id/videos');
    final moviedbVideosResponse = MoviedbVideosResponse.fromJson(response.data);

    final videos = <Video>[];

    for (var movieVideo in moviedbVideosResponse.results) {
      final Video video = VideoMapper.moviedbVideoToEntity(movieVideo);
      videos.add(video);
    }

    return videos;
   
  }
  
  @override
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final response = await dio.get('/movie/$movieId/similar');

    return _jsonToMovies(response.data);
  }
}
