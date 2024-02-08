import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

final isMovieFavoriteProvider = FutureProvider.family.autoDispose((ref , int movieId ){
  final localStorageRepository = ref.watch(LocalStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
});
