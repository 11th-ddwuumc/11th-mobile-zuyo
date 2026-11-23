import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movielog/core/network/api_error.dart';
import 'package:movielog/core/session/session_guard.dart';
import 'package:movielog/core/utils/map_bounded.dart';
import 'package:movielog/core/utils/safe_notify.dart';
import 'package:movielog/models/favorite_list_item.dart';
import 'package:movielog/models/favorite_response_dto.dart';
import 'package:movielog/services/favorite_api_service.dart';
import 'package:movielog/services/tmdb_movie_service.dart';
import 'package:movielog/view_models/load_phase.dart';

class FavoritesViewModel extends ChangeNotifier with SafeNotify {
  FavoritesViewModel({
    required this.favoriteApi,
    required this.tmdbApi,
    required this.sessionGuard,
    required this.accountId,
    required this.expireSession,
    this.enrichmentConcurrency = 5,
  });

  final FavoriteApiService favoriteApi;
  final TmdbMovieService tmdbApi;
  final SessionGuard sessionGuard;
  final String accountId;
  final Future<void> Function() expireSession;
  final int enrichmentConcurrency;

  LoadPhase phase = LoadPhase.idle;
  List<FavoriteListItem> items = const [];
  String? errorMessage;
  int _refreshGeneration = 0;
  late final int _sessionGeneration = sessionGuard.generation;
  final _retrying = <int>{};

  bool isRetrying(int movieId) => _retrying.contains(movieId);

  bool _isCurrent(int refreshGeneration) =>
      !isDisposed &&
      sessionGuard.isCurrent(_sessionGeneration, accountId) &&
      refreshGeneration == _refreshGeneration;

  Future<FavoriteListItem> _enrich(FavoriteResponseDto favorite) async {
    try {
      final movie = await tmdbApi.fetchMovieDetail(favorite.movieId);
      return FavoriteListItem(favorite: favorite, movie: movie);
    } catch (_) {
      return FavoriteListItem(
        favorite: favorite,
        errorMessage: '영화 정보를 불러오지 못했습니다.',
      );
    }
  }

  Future<void> retryMovie(FavoriteListItem item) async {
    final generation = _refreshGeneration;
    final movieId = item.favorite.movieId;
    if (!_isCurrent(generation) || !_retrying.add(movieId)) return;
    notifyIfAlive();
    final updated = await _enrich(item.favorite);
    if (!_isCurrent(generation)) return;
    _retrying.remove(movieId);
    items = [
      for (final current in items)
        if (current.favorite.movieId == movieId) updated else current,
    ];
    notifyIfAlive();
  }

  // 즐겨찾기 목록을 다시 조회하고 TMDB 영화 정보를 최대 5개씩 보충합니다.
  Future<void> refresh() async {
    if (!_isCurrent(_refreshGeneration)) return;
    final refreshGeneration = ++_refreshGeneration;
    _retrying.clear();
    phase = LoadPhase.loading;
    errorMessage = null;
    notifyIfAlive();
    try {
      final favorites = await favoriteApi.fetchMyFavorites();
      if (!_isCurrent(refreshGeneration)) return;
      final enriched = await mapBounded(
        favorites,
        enrichmentConcurrency,
        _enrich,
      );
      if (!_isCurrent(refreshGeneration)) return;
      items = enriched;
      phase = items.isEmpty ? LoadPhase.empty : LoadPhase.ready;
    } catch (error) {
      if (!_isCurrent(refreshGeneration)) return;
      if (error is DioException && error.response?.statusCode == 401) {
        final code = apiErrorCode(error);
        if (code == 'AUTH401_2' || code == 'AUTH401_3' || code == 'AUTH401_4') {
          await expireSession();
          return;
        }
      }
      phase = LoadPhase.error;
      errorMessage = '내 즐겨찾기 목록을 불러오지 못했습니다.';
    } finally {
      if (_isCurrent(refreshGeneration)) notifyIfAlive();
    }
  }
}
