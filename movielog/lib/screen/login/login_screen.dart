import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/view_models/auth_view_model.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/widgets/movielog_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  late final AuthViewModel _auth;

  @override
  void initState() {
    super.initState();
    _auth = context.read<AuthViewModel>();
    _auth.addListener(_showSessionExpired);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showSessionExpired());
  }

  void _showSessionExpired() {
    if (!mounted || !_auth.sessionExpired) return;
    _auth.consumeSessionExpired();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('로그인이 만료됐어요. 다시 로그인해 주세요.')));
  }

  @override
  void dispose() {
    _auth.removeListener(_showSessionExpired);
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final loading = auth.status == AuthStatus.authenticating;
    final enabled = !loading && !auth.storageCleanupInProgress;
    const background = Color(0xFFFFFCFA);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFDDD6E8)),
    );
    InputDecoration decoration({String? error}) => InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border,
      enabledBorder: border,
      disabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: AppColors.primary500),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: Color(0xFFFF4949)),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: Color(0xFFFF4949)),
      ),
      errorText: error,
      errorMaxLines: 3,
      errorStyle: const TextStyle(color: AppColors.error, fontSize: 11),
    );

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        centerTitle: true,
        title: const Text(
          '로그인',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary500,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 80),
                      Center(
                        child: SvgPicture.asset(
                          'assets/logos/movielog_logo.svg',
                          width: 84,
                          height: 84,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'MovieLog에 로그인',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        '이메일',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _email,
                        enabled: enabled,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        style: const TextStyle(fontSize: 14),
                        decoration: decoration(),
                        validator: (value) => (value?.trim().isEmpty ?? true)
                            ? '이메일을 입력해 주세요.'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '비밀번호',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _password,
                        enabled: enabled,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: const TextStyle(fontSize: 14),
                        decoration: decoration(error: auth.message),
                        validator: (value) =>
                            (value?.isEmpty ?? true) ? '비밀번호를 입력해 주세요.' : null,
                        onFieldSubmitted: enabled ? (_) => _submit() : null,
                      ),
                      // 오류 문구가 생겨도 버튼 위치는 유지합니다.
                      SizedBox(height: auth.message == null ? 112 : 88),
                      MovieLogButton(
                        label: '로그인',
                        width: double.infinity,
                        isLoading: loading,
                        onPressed: enabled ? _submit : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '계정이 없나요?',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          TextButton(
                            onPressed: enabled
                                ? () => context.push('/signup')
                                : null,
                            child: const Text(
                              '회원가입',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _auth.login(_email.text.trim(), _password.text);
    }
  }
}
