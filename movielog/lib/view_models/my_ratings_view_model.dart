import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movielog/core/network/api_error.dart';
import 'package:movielog/view_models/auth_view_model.dart';
import 'package:movielog/models/rating_with_movie.dart';
import 'package:movielog/models/tmdb_movie_dto.dart';
import 'package:movielog/services/rating_api_service.dart';
import 'package:movielog/services/tmdb_movie_service.dart';

const int sampleMemberId = 1; // 인증된 ‘내 계정’이 아닌 학습용 데이터입니다.

enum MyRatingsLoadStatus { idle, loading, success, empty, error }

class MyRatingsViewModel extends ChangeNotifier {
  MyRatingsViewModel(this._service, this._movieService, this.memberId, this._auth);
  final AuthViewModel _auth;
  final RatingApiService _service;
  final TmdbMovieService _movieService;
  final int memberId;
  final Map<int, TmdbMovieDto?> _movieCache = {};
  int _requestVersion = 0;
  bool _disposed = false;
  String? refreshWarning;

  List<RatingWithMovie> ratings = const [];
  MyRatingsLoadStatus status = MyRatingsLoadStatus.idle;
  String? message;

  Future<void> load() async {
    if (_disposed) return;
    final session = _auth.sessionVersion;
    final version = ++_requestVersion;
    status = MyRatingsLoadStatus.loading;
    message = null;
    refreshWarning = null;
    notifyListeners();
    try {
      final rawRatings = await _service.fetchMyRatings(memberId);
      if (_disposed || version != _requestVersion || session != _auth.sessionVersion) {
        return;
      }
      final entries = <RatingWithMovie>[];
      var missingMovies = 0;
      // 중복 ID를 제거하고 영화 정보를 병렬 조회합니다.
      final movieIds = rawRatings.map((rating) => rating.movieId).toSet();
      await Future.wait(
        movieIds.map((movieId) async {
          if (_movieCache.containsKey(movieId)) {
            return;
          }
          try {
            final movie = await _movieService.findMovieById(movieId);
            if (_disposed || version != _requestVersion || session != _auth.sessionVersion) {
              return;
            }
            _movieCache[movieId] = movie;
          } catch (_) {
            // 영화 정보 오류가 평점 목록을 지우지 않으며 다음 조회에서 재시도합니다.
          }
        }),
      );
      if (_disposed || version != _requestVersion || session != _auth.sessionVersion) {
        return;
      }
      for (final rating in rawRatings) {
        final movie = _movieCache[rating.movieId];
        if (movie == null) {
          missingMovies++;
        }
        entries.add(RatingWithMovie(rating: rating, movie: movie));
      }
      if (_disposed || version != _requestVersion || session != _auth.sessionVersion) {
        return;
      }
      ratings = entries;
      status = entries.isEmpty
          ? MyRatingsLoadStatus.empty
          : MyRatingsLoadStatus.success;
      if (missingMovies > 0) {
        message = '일부 영화 정보를 가져오지 못해 제목·포스터를 대신 표시합니다.';
      }
    } on DioException catch (error) {
      if (_disposed || version != _requestVersion || session != _auth.sessionVersion) {
        return;
      }
      status = MyRatingsLoadStatus.error;
      message = switch (apiErrorCode(error)) {
        'MEMBER404_1' => '회원 정보를 찾을 수 없어요.',
        'COMMON400' => apiErrorMessage(error) ?? '조회 정보를 확인해 주세요.',
        _ => '평점을 불러오지 못했어요. 다시 시도해 주세요.',
      };
    } catch (_) {
      if (_disposed || version != _requestVersion || session != _auth.sessionVersion) {
        return;
      }
      status = MyRatingsLoadStatus.error;
      message = '평점을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.';
    }
    if (!_disposed && version == _requestVersion && session == _auth.sessionVersion) {
      notifyListeners();
    }
  }

  bool _isCurrent(int session) =>
      !_disposed && session == _auth.sessionVersion &&
      _auth.status == AuthStatus.signedIn;

  Future<void> _handleWriteError(DioException error, int session) async {
    if (!_isCurrent(session)) return;
    final code = apiErrorCode(error);
    if (code == 'AUTH401_2' || code == 'AUTH401_3' || code == 'AUTH401_4') {
      await _auth.expireSession();
      return;
    }
    final errorMessage = switch (code) {
      'RATING403_1' => '본인이 작성한 평점만 변경할 수 있어요.',
      'RATING404_1' => '존재하지 않는 평점이에요.',
      'RATING409_1' => '이미 등록된 평점과 충돌했어요.',
      'COMMON400' => apiErrorMessage(error) ?? '입력값을 확인해 주세요.',
      _ => '요청에 실패했어요. 다시 시도해 주세요.',
    };
    if (code == 'RATING404_1') await load();
    if (!_isCurrent(session)) return;
    message = errorMessage;
    notifyListeners();
  }

  Future<void> updateRating({
    required int ratingId,
    required int score,
    String? comment,
  }) async {
    final session = _auth.sessionVersion;
    if (!_isCurrent(session)) throw StateError('로그인이 필요해요.');
    try {
      final updated = await _service.updateRating(
        ratingId: ratingId, score: score, comment: comment,
      );
      if (!_isCurrent(session)) return;
      ratings = [
        for (final entry in ratings)
          if (entry.rating.ratingId == ratingId)
            RatingWithMovie(rating: updated, movie: entry.movie)
          else entry,
      ];
      message = null;
      notifyListeners();
    } on DioException catch (error) {
      await _handleWriteError(error, session);
      rethrow;
    }
  }

  Future<void> deleteRating(int ratingId) async {
    final session = _auth.sessionVersion;
    if (!_isCurrent(session)) throw StateError('로그인이 필요해요.');
    try {
      await _service.deleteRating(ratingId);
      if (!_isCurrent(session)) return;
      ratings = ratings.where((entry) => entry.rating.ratingId != ratingId).toList();
      status = ratings.isEmpty ? MyRatingsLoadStatus.empty : MyRatingsLoadStatus.success;
      message = null;
      notifyListeners();
    } on DioException catch (error) {
      await _handleWriteError(error, session);
      rethrow;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _requestVersion++;
    super.dispose();
  }
}
