import 'package:cinemapedia/domian/entities/movie.dart';

abstract class MoviesDataSources {


  Future<List<Movie>> getNowPlaying({int page = 1});


}