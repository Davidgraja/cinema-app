
import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/domian/datasources/movies_datasources.dart';
import 'package:cinemapedia/domian/repositories/movies_repository.dart';

class MovieRepositoryImpl extends MoviesRepository {

  final MoviesDataSources movieDatasource;

  MovieRepositoryImpl(this.movieDatasource);


  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) {
    return movieDatasource.getNowPlaying(page: page);
  }

}