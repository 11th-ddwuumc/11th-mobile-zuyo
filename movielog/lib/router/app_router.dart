import 'package:go_router/go_router.dart';
import 'package:movielog/core/session/session_guard.dart';
import 'package:movielog/core/storage/member_id_storage.dart';
import 'package:movielog/screen/home/home_screen.dart';
import 'package:movielog/screen/login/login_screen.dart';
import 'package:movielog/screen/main_screen.dart';
import 'package:movielog/screen/movie/movie_detail_loader.dart';
import 'package:movielog/screen/movie/movie_screen.dart';
import 'package:movielog/screen/profile/edit_profile_screen.dart';
import 'package:movielog/screen/profile/favorites_screen.dart';
import 'package:movielog/screen/profile/my_ratings_screen.dart';
import 'package:movielog/screen/profile/profile_screen.dart';
import 'package:movielog/screen/signup/signup_screen.dart';
import 'package:movielog/screen/splash_screen.dart';
import 'package:movielog/services/member_api_service.dart';
import 'package:movielog/services/favorite_api_service.dart';
import 'package:movielog/services/sign_up_service.dart';
import 'package:movielog/services/rating_api_service.dart';
import 'package:movielog/services/tmdb_movie_service.dart';
import 'package:movielog/view_models/auth_view_model.dart';
import 'package:movielog/view_models/edit_profile_view_model.dart';
import 'package:movielog/view_models/favorite_detail_view_model.dart';
import 'package:movielog/view_models/favorites_view_model.dart';
import 'package:movielog/view_models/movie_home_view_model.dart';
import 'package:movielog/view_models/page_movies_view_model.dart';
import 'package:movielog/view_models/my_ratings_view_model.dart';
import 'package:movielog/view_models/signup_view_model.dart';
import 'package:movielog/widgets/movielog_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:movielog/models/tmdb_movie_dto.dart';

class AppRouter {
  AppRouter._();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(AuthViewModel authViewModel) {
    return GoRouter(
      initialLocation: '/start',
      navigatorKey: rootNavigatorKey,
      refreshListenable: authViewModel, // 인증 상태가 바뀌면 redirect를 다시 실행합니다.
      redirect: (context, state){
        return authRedirect(authViewModel.status, state.uri.path);
      },
      routes: [
        GoRoute(
          path: '/start', // 스플래시: 토큰 확인 중 / 확인 실패 시 재시도
          builder: (context, state) {
            final auth = context.watch<AuthViewModel>();
            return SplashScreen(
              message: auth.message,
              onRetry: auth.status == AuthStatus.retryRequired
                ? auth.restoreSession
                : null,
            );
          }
        ),
        GoRoute(
          path: '/login',
          builder:(context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => ChangeNotifierProvider<SignUpViewModel>(
            create: (context) => SignUpViewModel(
              context.read<SignUpService>(),
              context.read<MemberIdStorage>(),
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
              builder: (context, state) => ChangeNotifierProvider<PagedMoviesViewModel>(
                create: (context) => PagedMoviesViewModel(
                  tmdbApi: context.read<TmdbMovieService>(),
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
                    final auth = context.watch<AuthViewModel>();
                    final email = auth.member?.email;
                    final guard = context.read<SessionGuard>();

                    if (auth.status != AuthStatus.signedIn ||
                        email == null || guard.accountId != email) {
                      return Scaffold(
                        appBar: AppBar(title: const Text('영화 상세')),
                        body: Center(
                          child: auth.memberStatus == MemberLoadStatus.error
                              ? MovieLogButton(
                                  label: '내 정보 다시 불러오기',
                                  onPressed: () => auth.loadMember(force: true),
                                )
                              : const CircularProgressIndicator(),
                        ),
                      );
                    }

                    return ChangeNotifierProvider<FavoriteDetailViewModel>(
                      key: ValueKey((id, email, guard.generation)),
                      create: (context) => FavoriteDetailViewModel(
                        movieId: id,
                        favoriteApi: context.read<FavoriteApiService>(),
                        sessionGuard: guard,
                        accountId: email,
                        expireSession: auth.expireSession,
                      )..load(),
                      child: MovieDetailLoader(
                        movieId: id,
                        initialMovie: extra is TmdbMovieDto && extra.id == id
                            ? extra
                            : null,
                      ),
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
                    final auth = context.watch<AuthViewModel>();
                    final id = auth.member?.memberId;
                    if (id == null) {
                      final loading = auth.memberStatus == MemberLoadStatus.idle ||
                          auth.memberStatus == MemberLoadStatus.loading;
                      return Scaffold(
                        appBar: AppBar(centerTitle: true, title: const Text('내가 등록한 평점')),
                        body: Center(
                          child: loading
                              ? const CircularProgressIndicator()
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      auth.memberStatus == MemberLoadStatus.error
                                          ? '내 정보를 불러오지 못했어요.'
                                          : '이 기기에 저장된 회원 ID를 찾지 못했어요.',
                                    ),
                                    MovieLogButton(
                                      label: '다시 시도',
                                      onPressed: () => auth.loadMember(force: true),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    }
                    return ChangeNotifierProvider<MyRatingsViewModel>(
                      key: ValueKey((auth.sessionVersion, id)),
                      create: (context) => MyRatingsViewModel(
                        context.read<RatingApiService>(),
                        context.read<TmdbMovieService>(),
                        id,
                        auth,
                      )..load(),
                      child: const MyRatingsScreen(),
                    );
                  },
                ),

                GoRoute(
                  path: 'favorites',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final auth = context.watch<AuthViewModel>();
                    final email = auth.member?.email;
                    final guard = context.read<SessionGuard>();
                    if (auth.status != AuthStatus.signedIn ||
                        email == null ||
                        guard.accountId != email) {
                      return Scaffold(
                        appBar: AppBar(
                          centerTitle: true,
                          title: const Text('내 즐겨찾기'),
                        ),
                        body: Center(
                          child: auth.memberStatus == MemberLoadStatus.error
                              ? MovieLogButton(
                                  label: '내 정보 다시 불러오기',
                                  onPressed: () => auth.loadMember(force: true),
                                )
                              : const CircularProgressIndicator(),
                        ),
                      );
                    }
                    return ChangeNotifierProvider<FavoritesViewModel>(
                      key: ValueKey((email, guard.generation)),
                      create: (context) => FavoritesViewModel(
                        favoriteApi: context.read<FavoriteApiService>(),
                        tmdbApi: context.read<TmdbMovieService>(),
                        sessionGuard: guard,
                        accountId: email,
                      ),
                      child: FavoritesScreen(
                        onOpenMovie: (movie) async {
                          await context.push('/movies/${movie.id}', extra: movie);
                        },
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: 'profile/edit',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) {
                    final auth = context.watch<AuthViewModel>();
                    if (auth.member == null) {
                      return Scaffold(
                        appBar: AppBar(centerTitle: true, title: const Text('프로필 수정')),
                        body: Center(
                          child: auth.memberStatus == MemberLoadStatus.error
                              ? MovieLogButton(label: '다시 시도', onPressed: () => auth.loadMember(force: true))
                              : const CircularProgressIndicator(),
                        ),
                      );
                    }
                    return ChangeNotifierProvider<EditProfileViewModel>(
                      create: (context) => EditProfileViewModel(context.read<MemberApiService>(), auth),
                      child: const EditProfileScreen(),
                    );
                  },
                )
              ]
            ),
          ],
        ),
      ],
    );
  }

  static int indexFromLocation(String path) {
    if (path.startsWith('/movies')) return 1;
    if (path.startsWith('/my')) return 2;
    return 0;
  }
}

String? authRedirect(AuthStatus status, String location) {
  const publicPaths = {'/login', '/signup'};
  final atStart = location == '/start';
  final atPublic = publicPaths.contains(location);

  return switch (status) {
    // 토큰 확인 중 또는 확인 실패(재시도 버튼): 스플래시 화면 유지
    AuthStatus.initializing ||
    AuthStatus.retryRequired => atStart ? null : '/start',
    // 로그아웃 또는 로그인 요청 중: 공개 화면만 허용
    AuthStatus.signedOut ||
    AuthStatus.authenticating => atPublic ? null : '/login',
    // 로그인됨: 스플래시와 로그인·회원가입 화면은 홈으로 보냄
    AuthStatus.signedIn => (atStart || atPublic) ? '/home' : null,
  };
}
