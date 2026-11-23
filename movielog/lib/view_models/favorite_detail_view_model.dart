import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:movielog/core/network/api_error.dart';
import 'package:movielog/core/session/session_guard.dart';
import 'package:movielog/core/utils/safe_notify.dart';
import 'package:movielog/services/favorite_api_service.dart';

class FavoriteDetailViewModel extends ChangeNotifier with SafeNotify {
  FavoriteDetailViewModel({
    required this.movieId,
    required this.favoriteApi,
    required this.sessionGuard,
    required this.accountId,
    required this.expireSession,
  }) : _generation = sessionGuard.generation;

  final int movieId;
  final FavoriteApiService favoriteApi;
  final SessionGuard sessionGuard;
  final String accountId;
  final int _generation;
  final Future<void> Function() expireSession;

  bool? isFavorite;
  bool isBusy = false;
  String? errorMessage;

  bool get isCurrent =>
      !isDisposed && sessionGuard.isCurrent(_generation, accountId);

  Future<void> load() => _run(_readStatus, '즐겨찾기 여부를 확인하지 못했어요.');

  Future<void> toggle() async {
    final before = isFavorite;
    if (before == null) return;

    await _run(() async {
      try {
        if (before) {
          await favoriteApi.deleteFavorite(movieId: movieId);
        } else {
          await favoriteApi.addFavorite(movieId: movieId);
        }
      } on DioException catch (error) {
        final code = apiErrorCode(error);
        if (code != 'FAVORITE409_1' && code != 'FAVORITE404_1') rethrow;
        if (!isCurrent) return;
        await _readStatus();
        return;
      }
      if (isCurrent) isFavorite = !before;
    }, before ? '즐겨찾기에서 해제하지 못했어요.' : '즐겨찾기에 추가하지 못했어요.');
  }

  Future<void> _readStatus() async {
    final result = await favoriteApi.checkFavorite(movieId: movieId);
    if (isCurrent) isFavorite = result.isFavorite;
  }

  Future<void> _run(
    Future<void> Function() request,
    String failureMessage,
  ) async {
    if (!isCurrent || isBusy) return;
    isBusy = true;
    errorMessage = null;
    notifyIfAlive();

    try {
      await request();
    } on DioException catch (error) {
      if (!isCurrent) return;
      switch (apiErrorCode(error)) {
        case 'AUTH401_2':
        case 'AUTH401_3':
        case 'AUTH401_4':
          await expireSession();
        case 'MEMBER404_1':
          errorMessage = '회원 정보를 찾을 수 없어요.';
        default:
          errorMessage = failureMessage;
      }
    } catch (_) {
      if (isCurrent) errorMessage = failureMessage;
    } finally {
      if (isCurrent) {
        isBusy = false;
        notifyIfAlive();
      }
    }
  }
}
