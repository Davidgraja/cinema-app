import 'package:go_router/go_router.dart';
import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/widgets/animations/navigation_animation.dart';

final appRouter = GoRouter(initialLocation: '/home/0', routes: [
  GoRoute(
      path: '/home/:page',
      name: HomeScreen.name,
      pageBuilder: (context, state) {
        int  pageIndex = int.parse (state.pathParameters['page'] ?? '0');
        if(pageIndex > 2 || pageIndex < 0) {
          pageIndex = 0;
        }
        return  navigationAnimation(HomeScreen(pageIndex: pageIndex));

      },
      routes: [
        GoRoute(
          path: 'movie/:id',
          name: MovieScreen.name,
          pageBuilder: (context, state) {
            final movieId = state.pathParameters['id'] ?? 'no-id';
            return  navigationAnimation( MovieScreen(movieId: movieId));
          },
        ),

      ]
    ),

  GoRoute(path: '/' ,redirect: ( _ , __) => '/home/0' ,)

  ]);
