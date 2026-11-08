import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movielog/models/create_member_request.dart';
import 'package:movielog/services/sign_up_service.dart';

enum CheckStatus { idle, checking, available, duplicated, error }
enum SubmitStatus { idle, submitting, success, error }

class SignUpViewModel extends ChangeNotifier {
  SignUpViewModel(this._service);
  final SignUpService _service;

  SubmitStatus submitStatus = SubmitStatus.idle;
  int? createdMemberId; // 가입 성공 응답에서 읽은 실제 ID입니다.
  String? passwordErrorText;
  String? snackbarMessage;

  // 닉네임
  CheckStatus nicknameCheckStatus = CheckStatus.idle;
  String? nicknameErrorText;
  String? _duplicatedNickname;
  String _currentNickname = '';
  int _requestVersion = 0;

  // 이메일
  CheckStatus emailCheckStatus = CheckStatus.idle;
  String? emailErrorText;
  String _currentEmail = '';
  int _emailRequestVersion = 0;

  bool _disposed = false;

  bool get canCheckNickname =>
      nicknameCheckStatus != CheckStatus.checking &&
      nicknameCheckStatus != CheckStatus.duplicated;

  bool get canCheckEmail =>
      emailCheckStatus != CheckStatus.checking &&
      emailCheckStatus != CheckStatus.duplicated;

  // 닉네임 입력 변경 처리 및 중복 상태 갱신
  void onNicknameChanged(String value) {
    _resetSubmitState();
    final trimmed = value.trim();
    _currentNickname = trimmed;
    _requestVersion++; // 이전 요청의 응답을 무효화합니다.
    if (_duplicatedNickname != null && trimmed == _duplicatedNickname) {
      nicknameCheckStatus = CheckStatus.duplicated;
      nicknameErrorText = '이미 사용 중인 닉네임입니다.';
    } else {
      nicknameCheckStatus = CheckStatus.idle;
      nicknameErrorText = null;
    }
    if (!_disposed) {
      notifyListeners();
    }
  }

  // 닉네임 확인
  Future<void> checkNickname(String value) async {
    final requested = value.trim();
    if (requested.isEmpty ||
        requested != _currentNickname ||
        !canCheckNickname) {
      return;
    }

    final version = ++_requestVersion;
    nicknameCheckStatus = CheckStatus.checking;
    nicknameErrorText = null;
    notifyListeners();

    try {
      final available = await _service.checkNickname(requested);
      if (_disposed ||
          version != _requestVersion ||
          _currentNickname != requested) {
        return;
      }
      nicknameCheckStatus = available
          ? CheckStatus.available
          : CheckStatus.duplicated;
      nicknameErrorText = available ? null : '이미 사용 중인 닉네임입니다.';
      if (!available) {
        _duplicatedNickname = requested;
      }
    } catch (_) {
      if (_disposed ||
          version != _requestVersion ||
          _currentNickname != requested) {
        return;
      }
      nicknameCheckStatus = CheckStatus.error;
      nicknameErrorText = '중복 확인에 실패했습니다. 다시 시도해 주세요.';
    }
    if (!_disposed && version == _requestVersion) {
      notifyListeners();
    }
  }

  // 이메일 입력 변경 처리
  void onEmailChanged(String value) {
    _resetSubmitState();
    final trimmed = value.trim();
    _currentEmail = trimmed;
    _emailRequestVersion++;

    emailCheckStatus = CheckStatus.idle;
    emailErrorText = null;

    if (!_disposed) {
      notifyListeners();
    }
  }

  // 이메일 확인
  Future<void> checkEmail(String value) async {
    final requested = value.trim();

    if (requested.isEmpty || requested != _currentEmail || !canCheckEmail) {
      return;
    }

    final version = ++_emailRequestVersion;
    emailCheckStatus = CheckStatus.checking;
    emailErrorText = null;
    notifyListeners();

    try {
      final available = await _service.checkEmail(requested);
      if (_disposed ||
          version != _emailRequestVersion ||
          _currentEmail != requested) {
        return;
      }
      emailCheckStatus = available
          ? CheckStatus.available
          : CheckStatus.duplicated;
      emailErrorText = available ? null : '이미 사용 중인 이메일입니다.';
    } catch (_) {
      if (_disposed ||
          version != _emailRequestVersion ||
          _currentEmail != requested) {
        return;
      }
      emailCheckStatus = CheckStatus.error;
      emailErrorText = '중복 확인에 실패했습니다. 다시 시도해 주세요.';
    }
    if (!_disposed && version == _emailRequestVersion) {
      notifyListeners();
    }
  }

  // 비밀번호
  void onPasswordChanged() {
    _resetSubmitState();
    notifyListeners();
  }

  // 제출 
  Future<void> submit(CreateMemberRequest request) async {
    if (_disposed || submitStatus == SubmitStatus.submitting) return;

    submitStatus = SubmitStatus.submitting;
    createdMemberId = null;
    passwordErrorText = null;
    snackbarMessage = null;
    notifyListeners();

    try {
      final response = await _service.signUp(request);
      if (_disposed) return;

      final id = response.result?.memberId;

      if (!response.isSuccess || id == null) {
        throw StateError('회원가입 성공 결과를 확인할 수 없습니다.');
      }

      createdMemberId = id;
      submitStatus = SubmitStatus.success;
    } on DioException catch (error) {
      if (_disposed) return;

      submitStatus = SubmitStatus.error;

      var message = '회원가입에 실패했습니다. 잠시 후 다시 시도해 주세요.';
      try {
        message = writeSignUpErrorMessage(error);
      } catch (_) {
      }

      if (error.response?.statusCode == 400 &&
          message.contains('비밀번호')) {
        passwordErrorText = message;
      } else {
        snackbarMessage = message;
      }
    } catch (_) {
      if (_disposed) return;

      submitStatus = SubmitStatus.error;
      snackbarMessage = '가입 결과를 확인하지 못했습니다. 새 요청 전에 서버 상태를 확인해 주세요.';
    }

    if (!_disposed) {
      notifyListeners();
    }
  }
  void _resetSubmitState() {
    submitStatus = SubmitStatus.idle;
    createdMemberId = null;
    passwordErrorText = null;
    snackbarMessage = null;
  }

  @override
  void dispose() {
    _disposed = true;
    _requestVersion++;
    _emailRequestVersion++;
    super.dispose();
  }
}
