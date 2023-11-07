import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';

final firstLoadingProvider = Provider<bool>((ref) {
  final provider1 = ref.watch(nowPlayingMoviesProvider).isEmpty;
  final provider3 = ref.watch(topRatedMoviesProvider).isEmpty;
  final provider4 = ref.watch(upcomingMoviesProvider).isEmpty;

  if(provider1  || provider3 || provider4) return true;

  return false;
});
