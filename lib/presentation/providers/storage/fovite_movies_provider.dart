

import 'package:cinemapedia/domian/entities/movie.dart';
import 'package:cinemapedia/domian/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider = StateNotifierProvider<StorageMoviesNotifier , Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(LocalStorageRepositoryProvider);
  return  StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});


class StorageMoviesNotifier  extends StateNotifier<Map<int , Movie>> {

  final LocalStorageRepository localStorageRepository;

  final page = 0;

  StorageMoviesNotifier({ required this.localStorageRepository }):super({});

  Future<void> loadNextPage() async {
    final movies = await localStorageRepository.loadMovies(offset: page * 10);

    final tempMoviesMap = <int , Movie>{};
    for(final movie in movies){
      tempMoviesMap[movie.id] = movie;
    }
    state = { ...state , ...tempMoviesMap};
  }

}