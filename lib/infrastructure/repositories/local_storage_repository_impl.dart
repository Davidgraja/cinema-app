import 'package:cinemapedia/domian/datasources/local_storage_datasources.dart';
import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/domian/repositories/local_storage_repository.dart';

class LocalStorageRepositoryimpl extends LocalStorageRepository{

  final LocalStorageDatasource datasource;

  LocalStorageRepositoryimpl(this.datasource);

  @override
  Future<bool> isMovieFavorite(int movieId) {
    return datasource.isMovieFavorite(movieId);
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) {
    return datasource.loadMovies(limit: limit, offset: offset);
  }

  @override
  Future<void> toggleFavorite(Movie movie) {
    return datasource.toggleFavorite(movie);
  }

}