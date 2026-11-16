import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movielog/models/rating_with_movie.dart';
import 'package:movielog/models/tmdb_movie_dto.dart';
import 'package:movielog/services/rating_api_service.dart';
import 'package:movielog/services/tmdb_movie_service.dart';

const int sampleMemberId = 1; // 인증된 ‘내 계정’이 아닌 학습용 데이터입니다.

enum MyRatingsLoadStatus { idle, loading, success, empty, error }

class MyRatingsViewModel extends ChangeNotifier {
  MyRatingsViewModel(this._service, this._movieService, this.memberId);
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
    final version = ++_requestVersion;
    status = MyRatingsLoadStatus.loading;
    message = null;
    refreshWarning = null;
    notifyListeners();
    try {
      final rawRatings = await _service.fetchMyRatings(memberId);
      if (_disposed || version != _requestVersion) {
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
            if (_disposed || version != _requestVersion) {
              return;
            }
            _movieCache[movieId] = movie;
          } catch (_) {
            // 영화 정보 오류가 평점 목록을 지우지 않으며 다음 조회에서 재시도합니다.
          }
        }),
      );
      if (_disposed || version != _requestVersion) {
        return;
      }
      for (final rating in rawRatings) {
        final movie = _movieCache[rating.movieId];
        if (movie == null) {
          missingMovies++;
        }
        entries.add(RatingWithMovie(rating: rating, movie: movie));
      }
      if (_disposed || version != _requestVersion) {
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
      if (_disposed || version != _requestVersion) {
        return;
      }
      status = MyRatingsLoadStatus.error;
      message = writeMyRatingsErrorMessage(error);
    } catch (_) {
      if (_disposed || version != _requestVersion) {
        return;
      }
      status = MyRatingsLoadStatus.error;
      message = '평점을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.';
    }
    if (!_disposed && version == _requestVersion) {
      notifyListeners();
    }
  }

  Future<void> _refreshAfterWrite() async {
    await load(); // 6주차 load()는 GET 실패를 status=error로 기록합니다.
    if (status == MyRatingsLoadStatus.error) {
      refreshWarning = '저장은 완료됐지만 목록을 불러오지 못했습니다. 조회만 다시 시도해 주세요.';
      notifyListeners();
    } else {
      refreshWarning = null;
    }
  }

  Future<void> updateRating({
    required int ratingId,
    required int score,
    String? comment,
  }) async {
    try {
      await _service.updateRating(
        memberId: memberId, ratingId: ratingId,
        score: score, comment: comment,
      );
    } on DioException catch (error) {
      message = writeErrorMessage(error);
      notifyListeners();
      if (shouldRefreshAfterRatingError(error)) await load();
      rethrow; // 쓰기 실패일 때만 Dialog가 실패로 처리합니다.
    }
    await _refreshAfterWrite(); // GET 실패는 저장 실패로 다시 던지지 않습니다.
  }

  Future<void> deleteRating(int ratingId) async {
    try {
      await _service.deleteRating(memberId: memberId, ratingId: ratingId);
    } on DioException catch (error) {
      message = writeErrorMessage(error);
      notifyListeners();
      if (shouldRefreshAfterRatingError(error)) await load();
      rethrow;
    }
    await _refreshAfterWrite();
  }

  @override
  void dispose() {
    _disposed = true;
    _requestVersion++;
    super.dispose();
  }
}
