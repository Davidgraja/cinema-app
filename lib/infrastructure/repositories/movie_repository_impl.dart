import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/domian/datasources/movies_datasources.dart';
import 'package:cinemapedia/domian/entities/video.dart';
import 'package:cinemapedia/domian/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {
  final MoviesDataSources movieDatasource;

  MovieRepositoryImpl(this.movieDatasource);

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return movieDatasource.getNowPlaying(page: page);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) {
    return movieDatasource.getPopular(page: page);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) {
    return movieDatasource.getTopRated(page: page);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) {
    return movieDatasource.getUpcoming(page: page);
  }

  @override
  Future<Movie> getMovieById(String id) {
    return movieDatasource.getMovieById(id);
  }
  
  @override
  Future<List<Movie>> searchMovies(String query) {
    return movieDatasource.searchMovies(query);
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId) {
    return movieDatasource.getSimilarMovies(movieId);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int id) {
    return movieDatasource.getYoutubeVideosById(id);
  }
}
