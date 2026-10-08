import 'package:go_router/go_router.dart';
import 'package:movielog/home/home_screen.dart';
import 'package:movielog/main_screen.dart';
import 'package:movielog/movie/movie_detail_screen.dart';
import 'package:movielog/movie/movie_screen.dart';
import 'package:movielog/profile/profile_screen.dart';
import 'package:movielog/signup/signup_screen.dart';
import 'package:movielog/start_screen.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/start',
    routes: [
      GoRoute(
        path: '/start',
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(
            currentIndex: indexFromLocation(state.uri.path),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/movies',
            builder: (context, state) => const MovieScreen(),
          ),
          GoRoute(
            path: '/my',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      GoRoute(
        path: '/movies/:movieId',
        builder: (context, state) {
          return MovieDetailScreen(
            movieId: state.pathParameters['movieId']!,
          );
        },
      ),
    ],
  );

  static int indexFromLocation(String path) {
    if (path.startsWith('/movies')) return 1;
    if (path.startsWith('/my')) return 2;
    return 0;
  }
}
