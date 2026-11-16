import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movielog/core/network/api_error.dart';
import 'package:movielog/models/rating_dto.dart';
import 'package:movielog/models/rating_request.dart';
import 'package:movielog/models/tmdb_movie_dto.dart';
import 'package:movielog/services/rating_api_service.dart';
import 'package:movielog/view_models/auth_view_model.dart';
import 'package:movielog/view_models/signup_view_model.dart';

class MovieDetailViewModel extends ChangeNotifier {
  MovieDetailViewModel(this._ratingService, this._auth, this.movie);

  final RatingApiService _ratingService;
  final AuthViewModel _auth;
  final TmdbMovieDto movie;
  SubmitStatus submitStatus = SubmitStatus.idle;
  String? submitMessage;
  bool _disposed = false;
  RatingDto? rating;

  Future<void> createRating({required int score, String? comment}) async {
    if (_disposed ||
        _auth.status != AuthStatus.signedIn ||
        submitStatus == SubmitStatus.submitting) {
      return;
    }

    final version = _auth.sessionVersion;
    submitStatus = SubmitStatus.submitting;
    submitMessage = null;
    notifyListeners();

    try {
      final created = await _ratingService.createRating(
        CreateRatingRequest(
          movieId: movie.id,
          score: score,
          comment: comment,
        ),
      );

      if (_disposed || version != _auth.sessionVersion) return;
      rating = created;
      submitStatus = SubmitStatus.success;
    } on DioException catch (error) {
      if (_disposed || version != _auth.sessionVersion) return;

      submitStatus = SubmitStatus.error;
      final code = apiErrorCode(error);

      if (code == 'AUTH401_2' ||
          code == 'AUTH401_3' ||
          code == 'AUTH401_4') {
        await _auth.expireSession();
        return;
      }

      submitMessage = switch (code) {
        'RATING403_1' => '평점을 등록할 권한이 없어요.',
        'RATING409_1' => '이미 이 영화에 평점을 남겼어요.',
        _ => apiErrorMessage(error) ?? '평점을 등록하지 못했어요. 다시 시도해 주세요.',
      };
    } catch (_) {
      if (_disposed || version != _auth.sessionVersion) return;
      submitStatus = SubmitStatus.error;
      submitMessage = '평점 등록을 처리하지 못했어요. 다시 시도해 주세요.';
    }

    if (!_disposed && version == _auth.sessionVersion) {
      notifyListeners();
    }
  }

  Future<void> updateRating({
    required int score,
    String? comment,
  }) async {
    final current = rating;
    if (_disposed ||
        current == null ||
        _auth.status != AuthStatus.signedIn ||
        submitStatus == SubmitStatus.submitting) {
      return;
    }

    final version = _auth.sessionVersion;
    submitStatus = SubmitStatus.submitting;
    submitMessage = null;
    notifyListeners();

    try {
      final updated = await _ratingService.updateRating(
        ratingId: current.ratingId,
        score: score,
        comment: comment,
      );

      if (_disposed || version != _auth.sessionVersion) return;
      rating = updated;
      submitStatus = SubmitStatus.success;
    } on DioException catch (error) {
      if (_disposed || version != _auth.sessionVersion) return;

      submitStatus = SubmitStatus.error;
      final code = apiErrorCode(error);

      if (code == 'AUTH401_2' ||
          code == 'AUTH401_3' ||
          code == 'AUTH401_4') {
        await _auth.expireSession();
        return;
      }

      if (code == 'RATING404_1') rating = null;

      submitMessage = switch (code) {
        'RATING403_1' => '본인이 작성한 평점만 수정할 수 있어요.',
        'RATING404_1' => '평점을 찾을 수 없어요.',
        'RATING409_1' => '이미 등록된 평점과 충돌했어요.',
        _ => apiErrorMessage(error) ?? '평점을 수정하지 못했어요. 다시 시도해 주세요.',
      };
    } catch (_) {
      if (_disposed || version != _auth.sessionVersion) return;
      submitStatus = SubmitStatus.error;
      submitMessage = '평점 수정을 처리하지 못했어요. 다시 시도해 주세요.';
    }

    if (!_disposed && version == _auth.sessionVersion) {
      notifyListeners();
    }
  }

  Future<void> deleteRating() async {
    final current = rating;
    if (_disposed ||
        current == null ||
        _auth.status != AuthStatus.signedIn ||
        submitStatus == SubmitStatus.submitting) {
      return;
    }

    final version = _auth.sessionVersion;
    submitStatus = SubmitStatus.submitting;
    submitMessage = null;
    notifyListeners();

    try {
      await _ratingService.deleteRating(current.ratingId);

      if (_disposed || version != _auth.sessionVersion) return;
      rating = null;
      submitStatus = SubmitStatus.success;
    } on DioException catch (error) {
      if (_disposed || version != _auth.sessionVersion) return;

      submitStatus = SubmitStatus.error;
      final code = apiErrorCode(error);

      if (code == 'AUTH401_2' ||
          code == 'AUTH401_3' ||
          code == 'AUTH401_4') {
        await _auth.expireSession();
        return;
      }

      if (code == 'RATING404_1') rating = null;

      submitMessage = switch (code) {
        'RATING403_1' => '본인이 작성한 평점만 삭제할 수 있어요.',
        'RATING404_1' => '이미 삭제되었거나 존재하지 않는 평점이에요.',
        _ => apiErrorMessage(error) ?? '평점을 삭제하지 못했어요. 다시 시도해 주세요.',
      };
    } catch (_) {
      if (_disposed || version != _auth.sessionVersion) return;
      submitStatus = SubmitStatus.error;
      submitMessage = '평점 삭제를 처리하지 못했어요. 다시 시도해 주세요.';
    }

    if (!_disposed && version == _auth.sessionVersion) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
