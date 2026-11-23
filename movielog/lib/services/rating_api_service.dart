import 'package:dio/dio.dart';
import 'package:movielog/models/common_response.dart';
import 'package:movielog/models/rating_dto.dart';
import 'package:movielog/models/rating_request.dart';

RatingDto parseRatingResult(Object? data) {
  if (data is! Map<String, dynamic>) throw StateError('평점 응답 형식이 올바르지 않습니다.');
  
  final common = CommonResponse<RatingDto>.fromJson(
    data, (value) => RatingDto.fromJson(value as Map<String, dynamic>),
  );
  
  final rating = common.result;
  
  if (rating == null) throw StateError('평점 result가 없습니다.');
  
  return rating;
}

List<RatingDto> parseRatingList(Object? data) {
  if (data is! List) throw StateError('평점 목록 응답은 배열이어야 합니다.');
  
  return data.map((value) => RatingDto.fromJson(value as Map<String, dynamic>)).toList();
}

class RatingApiService {
  RatingApiService(this._publicDio, this._authDio);
  final Dio _publicDio;
  final Dio _authDio;
  
  Future<List<RatingDto>> fetchMyRatings(int memberId) async {
    final response = await _publicDio.get('/v7/members/$memberId/ratings');
    return parseRatingList(response.data); // 공개 조회: 직접 배열, 토큰 없음
  }
  
  Future<RatingDto> createRating(CreateRatingRequest request) async {
    final response = await _authDio.post('/v7/ratings', data: request.toJson());
    return parseRatingResult(response.data);
  }
  
  Future<RatingDto> updateRating({required int ratingId, required int score, String? comment}) async {
    final response = await _authDio.patch('/v7/ratings/$ratingId', data: {'score': score, 'comment': comment});
    return parseRatingResult(response.data);
  }
  
  Future<void> deleteRating(int ratingId) async {
    final response = await _authDio.delete('/v7/ratings/$ratingId');
    if (response.statusCode != 200) throw StateError('예상하지 못한 삭제 응답');
  }
}