import 'package:flutter/material.dart';
import 'package:movielog/common_app_bar.dart';
import 'package:movielog/signup/signup_field.dart';
import 'package:movielog/signup/signup_footer.dart';
import 'package:movielog/signup/signup_validator.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  // 닉네임
  final _nicknameController = TextEditingController();
  bool _nicknameEdited = false;
  // 이메일
  final _emailController = TextEditingController();
  bool _emailEdited = false;
  final _emailFocusNode = FocusNode();
  // 비밀번호
  final _passwordController = TextEditingController();
  bool _passwordEdited = false;
  final _passwordFocusNode = FocusNode();

  // 가입 조건
  bool _agreed = false;

  bool get _canSubmit =>
      validateNickname(_nicknameController.text) == null &&
      validateEmail(_emailController.text) == null &&
      validatePassword(_passwordController.text) == null &&
      _agreed;

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || !_agreed) return;

    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '회원가입',
        centerTitle: true,
        onBack: () {
          Navigator.of(context).maybePop();
        },
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 32,
                            children: [
                              // 환영 문구
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Text(
                                  '환영합니다!\n간단한 정보만 입력하고 시작해보세요.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyLargeMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),

                              // 입력창
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 16,
                                children: [
                                  SignupField(
                                    label: '닉네임',
                                    hint: '닉네임을 입력해주세요',
                                    controller: _nicknameController,
                                    validator: validateNickname,
                                    showValidation: _nicknameEdited,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      _emailFocusNode.requestFocus();
                                    },
                                    onChanged: (_) {
                                      setState(() {
                                        _nicknameEdited = true;
                                      });
                                    },
                                  ),

                                  SignupField(
                                    label: '이메일',
                                    hint: '이메일을 입력해주세요',
                                    controller: _emailController,
                                    validator: validateEmail,
                                    showValidation: _emailEdited,
                                    focusNode: _emailFocusNode,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      _passwordFocusNode.requestFocus();
                                    },
                                    onChanged: (_) {
                                      setState(() {
                                        _emailEdited = true;
                                      });
                                    },
                                  ),

                                  SignupField(
                                    label: '비밀번호',
                                    hint: '비밀번호를 입력해주세요',
                                    controller: _passwordController,
                                    validator: validatePassword,
                                    showValidation: _passwordEdited,
                                    obscureText: true,
                                    focusNode: _passwordFocusNode,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) {
                                      _passwordFocusNode.unfocus();
                                    },
                                    onChanged: (_) {
                                      setState(() {
                                        _passwordEdited = true;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // 가입 조건 및 버튼
                        SignupFooter(
                          agreed: _agreed,
                          onAgreementChanged: (value) {
                            setState(() {
                              _agreed = value;
                            });
                          },
                          onSubmit: _canSubmit ? _submit : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}
