import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/view_models/signup_view_model.dart';
import 'package:movielog/widgets/common_app_bar.dart';
import 'package:movielog/screen/signup/widgets/signup_field.dart';
import 'package:movielog/screen/signup/widgets/signup_footer.dart';
import 'package:movielog/screen/signup/signup_validator.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';
import 'package:movielog/widgets/movielog_button.dart';
import 'package:provider/provider.dart';

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

  bool _canSubmit(SignUpViewModel viewModel) =>
      validateNickname(_nicknameController.text) == null &&
      validateEmail(_emailController.text) == null &&
      validatePassword(_passwordController.text) == null &&
      _agreed &&
      viewModel.nicknameCheckStatus == CheckStatus.available &&
      viewModel.emailCheckStatus == CheckStatus.available;

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    final viewModel = context.read<SignUpViewModel>();

    if(!_canSubmit(viewModel)){
      return;
    }

    if (!isValid || !_agreed) return;

    FocusScope.of(context).unfocus();
    context.go('/home');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SignUpViewModel>();

    return Scaffold(
      appBar: CommonAppBar(
        title: '회원가입',
        centerTitle: true,
        onBack: () {},
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
                                  Text(
                                    '닉네임',
                                    style: AppTextStyles.bodyLargeMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: SignupField(
                                          label: '닉네임',
                                          hint: '닉네임을 입력해주세요',
                                          controller: _nicknameController,
                                          validator: validateNickname,
                                          showValidation: _nicknameEdited,
                                          textInputAction: TextInputAction.next,
                                          onFieldSubmitted: (_) {
                                            _emailFocusNode.requestFocus();
                                          },
                                          errorText: viewModel.nicknameErrorText,
                                          onChanged: (value) {
                                            setState(() {
                                              _nicknameEdited = true;
                                            });
                                            viewModel.onNicknameChanged(value);
                                          },
                                          showLabel: false,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      MovieLogButton(
                                        label: '중복 확인',
                                        isLoading: viewModel.nicknameCheckStatus == CheckStatus.checking,
                                        onPressed: viewModel.canCheckNickname
                                            ? () => viewModel.checkNickname(_nicknameController.text)
                                            : null,
                                      ),
                                    ],
                                  ),
                                  if (viewModel.nicknameCheckStatus == CheckStatus.available)
                                    Text(
                                      '사용할 수 있는 닉네임입니다.',
                                      style: AppTextStyles.labelSmallBold.copyWith(
                                        fontSize: 12,
                                        color: Color(0xFF2E7D32)
                                      ),
                                    ),
                                  
                                  Text(
                                    '이메일',
                                    style: AppTextStyles.bodyLargeMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: SignupField(
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
                                          errorText: viewModel.emailErrorText,
                                          onChanged: (value) {
                                            setState(() {
                                              _emailEdited = true;
                                            });
                                            viewModel.onEmailChanged(value);
                                          },
                                          showLabel: false,
                                        ), 
                                      ),
                                      const SizedBox(width: 8),
                                      MovieLogButton(
                                        label: '중복 확인',
                                        isLoading: viewModel.emailCheckStatus == CheckStatus.checking,
                                        onPressed: viewModel.canCheckEmail
                                            ? () => viewModel.checkEmail(_emailController.text)
                                            : null,
                                      ),
                                    ],
                                  ),
                                  if (viewModel.emailCheckStatus == CheckStatus.available)
                                    Text(
                                      '사용할 수 있는 이메일입니다.',
                                      style: AppTextStyles.labelSmallBold.copyWith(
                                        fontSize: 12,
                                        color: Color(0xFF2E7D32)
                                      ),
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
                          onSubmit: _canSubmit(viewModel) ? _submit : null,
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
