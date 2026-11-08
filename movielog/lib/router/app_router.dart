import 'package:go_router/go_router.dart';
import 'package:movielog/screen/home/home_screen.dart';
import 'package:movielog/screen/main_screen.dart';
import 'package:movielog/screen/movie/movie_detail_screen.dart';
import 'package:movielog/screen/movie/movie_screen.dart';
import 'package:movielog/screen/profile/my_rating_screen.dart';
import 'package:movielog/screen/profile/profile_screen.dart';
import 'package:movielog/screen/signup/signup_screen.dart';
import 'package:movielog/screen/start_screen.dart';
import 'package:movielog/services/member_check_service.dart';
import 'package:movielog/services/rating_api_service.dart';
import 'package:movielog/services/tmdb_movie_service.dart';
import 'package:movielog/view_models/movie_home_view_model.dart';
import 'package:movielog/view_models/movie_list_view_model.dart';
import 'package:movielog/view_models/my_ratings_view_model.dart';
import 'package:movielog/view_models/signup_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:movielog/models/tmdb_movie_dto.dart';

class AppRouter {
  AppRouter._();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: '/start',
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/start',
        builder: (context, state) => const StartScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => ChangeNotifierProvider<SignUpViewModel>(
          create: (context) => SignUpViewModel(
            context.read<MemberCheckService>(),
          ),
          child: const SignupScreen(),
        ),
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
            builder: (context, state) => ChangeNotifierProvider<MovieHomeViewModel>(
              create: (context) => MovieHomeViewModel(
                context.read<TmdbMovieService>(),
              )..loadPopular(),
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/movies',
            builder: (context, state) => ChangeNotifierProvider<MovieListViewModel>(
              create: (context) => MovieListViewModel(
                context.read<TmdbMovieService>(),
              )..loadInitial(),
              child: const MovieScreen(),
            ),
          ),
          GoRoute(
            path: '/my',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'ratings', // 최종 경로: /my/ratings
                parentNavigatorKey: rootNavigatorKey, // root Navigator 위에 표시해 하단 NavigationBar를 가립니다.
                builder: (context, state) => ChangeNotifierProvider<MyRatingsViewModel>(
                  create: (context) => MyRatingsViewModel(
                    context.read<RatingApiService>(),
                    context.read<TmdbMovieService>(),
                    sampleMemberId, // 6주차는 학습용 ID 1입니다.
                  )..load(),
                  child: MyRatingsScreen(),
                ),
              ),
            ]
          ),
        ],
      ),

      GoRoute(
        path: '/movies/:movieId',
        builder: (context, state) {
          final extra = state.extra;

          if (extra is! ({
            TmdbMovieDto movie,
            List<String> genreNames,
          })) {
            return const Scaffold(
              body: Center(child: Text('영화 정보를 찾을 수 없습니다.')),
            );
          }

          return MovieDetailScreen(
            movie: extra.movie,
            genreNames: extra.genreNames,
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
