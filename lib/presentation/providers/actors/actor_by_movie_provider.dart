import 'package:cinemapedia/domian/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* 
  {
    '505491' : <Actor>[],
    '505491' : <Actor>[],
    '505491' : <Actor>[],
    '505491' : <Actor>[],
  }
 */

//? Providers
final actorsByMovieProvider =
    StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) {
  final fecthActors = ref.watch(actorsRepositoryProvider).getActorsByMovie;

  return ActorsByMovieNotifier(getActors: fecthActors);
});

//?  Case uses
typedef GetActorsCallback = Future<List<Actor>> Function(String movieId);

//? Notifier or controller of the state
class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {

  final GetActorsCallback getActors;

  ActorsByMovieNotifier({required this.getActors}) : super({});

  Future<void> loadActors(String movieId) async {
    if (state[movieId] != null) return;

    await Future.delayed(const Duration(milliseconds: 600));

    final List<Actor> actors = await getActors(movieId);

    state = {...state, movieId: actors};
  }
}
