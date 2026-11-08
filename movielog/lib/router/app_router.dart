import 'package:go_router/go_router.dart';
import 'package:movielog/screen/home/home_screen.dart';
import 'package:movielog/screen/main_screen.dart';
import 'package:movielog/screen/movie/movie_detail_loader.dart';
import 'package:movielog/screen/movie/movie_screen.dart';
import 'package:movielog/screen/profile/my_ratings_screen.dart';
import 'package:movielog/screen/profile/profile_screen.dart';
import 'package:movielog/screen/signup/signup_screen.dart';
import 'package:movielog/screen/start_screen.dart';
import 'package:movielog/services/sign_up_service.dart';
import 'package:movielog/services/rating_api_service.dart';
import 'package:movielog/services/tmdb_movie_service.dart';
import 'package:movielog/view_models/learning_member_session.dart';
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
            context.read<SignUpService>(),
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
            routes: [
              GoRoute(
                path: ':movieId',
                parentNavigatorKey: rootNavigatorKey,
                builder: (context, state) {
                  final id = int.tryParse(
                    state.pathParameters['movieId'] ?? '',
                  );

                  if (id == null || id < 1) {
                    return const Scaffold(
                      body: Center(child: Text('영화 ID가 올바르지 않습니다.')),
                    );
                  }

                  final extra = state.extra;

                  return MovieDetailLoader(
                    movieId: id,
                    initialMovie:
                        extra is TmdbMovieDto && extra.id == id ? extra : null,
                  );
                },
              ),
            ]
          ),
          
          GoRoute(
            path: '/my',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'ratings', // 최종 경로: /my/ratings
                parentNavigatorKey: AppRouter.rootNavigatorKey, // root Navigator 위에 표시해 하단 NavigationBar를 가립니다.
                builder: (context, state) {
                  final id = context.read<LearningMemberSession>().memberId;
                  if (id == null) {
                    return Scaffold(
                      appBar: AppBar(centerTitle: true, title: const Text('내가 등록한 평점')),
                      body: const Center(child: Text('학습용 회원가입이 필요합니다.')),
                    );
                  }
                  return ChangeNotifierProvider<MyRatingsViewModel>(
                    create: (context) => MyRatingsViewModel(
                      context.read<RatingApiService>(),
                      context.read<TmdbMovieService>(),
                      id,
                    )..load(),
                    child: const MyRatingsScreen(),
                  );
                },
              ),
            ]
          ),
        ],
      ),
    ],
  );

  static int indexFromLocation(String path) {
    if (path.startsWith('/movies')) return 1;
    if (path.startsWith('/my')) return 2;
    return 0;
  }
}
