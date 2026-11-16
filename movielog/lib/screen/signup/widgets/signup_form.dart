import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/models/create_member_request.dart';
import 'package:movielog/view_models/learning_member_session.dart';
import 'package:movielog/view_models/signup_view_model.dart';
import 'package:movielog/screen/signup/widgets/signup_field.dart';
import 'package:movielog/screen/signup/widgets/signup_footer.dart';
import 'package:movielog/screen/signup/signup_validator.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';
import 'package:movielog/screen/signup/widgets/signup_check_field.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
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

  bool _canSubmit(SignUpViewModel viewModel) =>
      validateNickname(_nicknameController.text) == null &&
      validateEmail(_emailController.text) == null &&
      validatePassword(_passwordController.text) == null &&
      _agreed &&
      viewModel.nicknameCheckStatus == CheckStatus.available &&
      viewModel.emailCheckStatus == CheckStatus.available &&
      viewModel.submitStatus != SubmitStatus.submitting;

  Future<void> _submit() async {
    final viewModel = context.read<SignUpViewModel>();

    if (!_canSubmit(viewModel)) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();

    await viewModel.submit(
      CreateMemberRequest(
        email: _emailController.text,
        password: _passwordController.text,
        nickname: _nicknameController.text,
      ),
    );

    if (!mounted) return;

    if (viewModel.submitStatus == SubmitStatus.success && 
        viewModel.createdMemberId != null) {
      context.read<LearningMemberSession>().setMemberId(viewModel.createdMemberId!);
      context.go('/movies');
      return;
    } else if (viewModel.snackbarMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.snackbarMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                    Consumer<SignUpViewModel>(
                      builder: (context, viewModel, child) => SignupCheckField(
                        label: '닉네임',
                        hint: '닉네임을 입력해주세요',
                        controller: _nicknameController,
                        validator: validateNickname,
                        showValidation: _nicknameEdited,

                        onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
                        errorText: viewModel.nicknameErrorText,
                        status: viewModel.nicknameCheckStatus,
                        onChanged: (value) {
                          setState(() => _nicknameEdited = true);
                          viewModel.onNicknameChanged(value);
                        },
                        onCheck: viewModel.canCheckNickname
                            ? () => viewModel.checkNickname(
                                _nicknameController.text,
                              )
                            : null,
                      ),
                    ),
                    Consumer<SignUpViewModel>(
                      builder: (context, viewModel, child) => SignupCheckField(
                        label: '이메일',
                        hint: '이메일을 입력해주세요',
                        controller: _emailController,
                        validator: validateEmail,
                        showValidation: _emailEdited,
                        focusNode: _emailFocusNode,
                        onFieldSubmitted: (_) =>
                            _passwordFocusNode.requestFocus(),
                        errorText: viewModel.emailErrorText,
                        status: viewModel.emailCheckStatus,
                        onChanged: (value) {
                          setState(() => _emailEdited = true);
                          viewModel.onEmailChanged(value);
                        },
                        onCheck: viewModel.canCheckEmail
                            ? () => viewModel.checkEmail(_emailController.text)
                            : null,
                      ),
                    ),
                    Consumer<SignUpViewModel>(
                      builder: (context, viewModel, child) => SignupField(
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
                        errorText: viewModel.passwordErrorText,
                        onChanged: (_) {
                          setState(() {
                            _passwordEdited = true;
                          });
                          viewModel.onPasswordChanged();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 가입 조건 및 버튼
          Consumer<SignUpViewModel>(
            builder: (context, viewModel, child) => SignupFooter(
              agreed: _agreed,
              onAgreementChanged: (value) {
                setState(() {
                  _agreed = value;
                });
              },
              onSubmit: _canSubmit(viewModel) ? _submit : null,
              isLoading: viewModel.submitStatus == SubmitStatus.submitting,
            ),
          ),
        ],
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
