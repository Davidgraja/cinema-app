import 'package:cinemapedia/infrastructure/datasource/moviedb_datasource.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//? Este reposirtorio es immutable, su objectivo es proporsionar a los demas providers  la informacion necesaria y puedan consultar la información necesaria dentro de la implementación del repositorio 

final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(MoviesdbDatasources());
});