import 'package:movielog/models/common_response.dart';

class MemberInfo {
  const MemberInfo({
    required this.email,
    required this.nickname,
    required this.createdAt,
    this.memberId,
  });

  final String email;
  final String nickname;
  final DateTime createdAt;
  final int? memberId;

  MemberInfo withMemberId(int? id) => MemberInfo(
    email: email,
    nickname: nickname,
    createdAt: createdAt,
    memberId: id,
  );
  
  factory MemberInfo.fromJson(Map<String, dynamic> json) {
    return MemberInfo(
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

MemberInfo parseMemberInfo(Object? data) {
  if (data is! Map<String, dynamic>) throw StateError('내 정보 응답 형식이 올바르지 않습니다.');
  final common = CommonResponse<MemberInfo>.fromJson(
    data, (value) => MemberInfo.fromJson(value as Map<String, dynamic>),
  );
  final member = common.result;
  if (member == null) throw StateError('내 정보 result가 없습니다.');
  return member;
}
