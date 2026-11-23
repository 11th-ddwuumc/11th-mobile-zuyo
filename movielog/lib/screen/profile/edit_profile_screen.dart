import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/view_models/auth_view_model.dart';
import 'package:movielog/view_models/edit_profile_view_model.dart';
import 'package:movielog/widgets/movielog_button.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final member = context.read<AuthViewModel>().member;
    _controller = TextEditingController(text: member?.nickname ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final viewModel = context.read<EditProfileViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    final success = await viewModel.save(_controller.text);
    if (!mounted) return;

    if (success) {
      messenger.showSnackBar(const SnackBar(content: Text('프로필을 수정했어요.')));
      router.pop(); // 마이페이지로 돌아가면 새 닉네임이 이미 반영되어 있습니다.
    } else if (viewModel.message != null) {
      messenger.showSnackBar(SnackBar(content: Text(viewModel.message!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = context.select<AuthViewModel, String?>(
      (a) => a.member?.email,
    );

    return Consumer<EditProfileViewModel>(
      builder: (context, viewModel, child) {
        final saving = viewModel.status == EditProfileStatus.saving;
        final border = OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFDDD6E8)),
        );
        InputDecoration decoration({bool readOnly = false, String? error}) =>
            InputDecoration(
              filled: true,
              fillColor: readOnly ? const Color(0xFFF0EDF3) : Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: border,
              enabledBorder: border,
              focusedBorder: readOnly
                  ? border
                  : border.copyWith(
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
              errorStyle: const TextStyle(fontSize: 12, color: AppColors.error),
            );
        return PopScope(
          canPop: !saving,
          child: Scaffold(
            backgroundColor: const Color(0xFFFFFCFA),
            appBar: AppBar(
              backgroundColor: const Color(0xFFFFFCFA),
              centerTitle: true,
              title: const Text(
                '프로필 수정',
                style: TextStyle(
                  color: AppColors.primary500,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              leading: IconButton(
                onPressed: saving ? null : () => context.pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary,
                ),
                tooltip: '뒤로가기',
              ),
            ),
            body: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: (constraints.maxHeight - 32).clamp(
                          0.0,
                          double.infinity,
                        ),
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 56),
                            const Text(
                              '이메일 (변경할 수 없습니다)',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              key: ValueKey(email),
                              initialValue: email,
                              readOnly: true,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.neutral800,
                              ),
                              decoration: decoration(readOnly: true),
                            ),
                            const SizedBox(height: 36),
                            const Text(
                              '닉네임',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _controller,
                              readOnly: saving,
                              maxLength: 12,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                              decoration: decoration(
                                error: viewModel.nicknameError,
                              ),
                            ),
                            const SizedBox(height: 32),
                            const Spacer(),
                            MovieLogButton(
                              label: '저장',
                              isLoading: saving,
                              width: double.infinity,
                              onPressed: saving ? null : _submit,
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
