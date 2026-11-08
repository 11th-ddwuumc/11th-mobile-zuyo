import 'package:flutter/material.dart';
import 'package:movielog/screen/signup/widgets/signup_form.dart';
import 'package:movielog/view_models/signup_view_model.dart';
import 'package:movielog/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(
      builder: (context, viewModel, child) {
        final isSubmitting = viewModel.submitStatus == SubmitStatus.submitting;
        return PopScope(
          canPop: !isSubmitting,
          child: Scaffold(
            appBar: CommonAppBar(
              title: '회원가입',
              centerTitle: true,
              onBack: () {
                if (!isSubmitting) {
                  Navigator.of(context).maybePop();
                }
              },
            ),
            body: SafeArea(
              child: AbsorbPointer(
                absorbing: isSubmitting,
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SignupForm(),
      ),
    );
  }
}
