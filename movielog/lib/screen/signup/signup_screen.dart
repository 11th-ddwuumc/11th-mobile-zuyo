import 'package:flutter/material.dart';
import 'package:movielog/screen/signup/widgets/signup_form.dart';
import 'package:movielog/widgets/common_app_bar.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: '회원가입', centerTitle: true, onBack: () {}),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SignupForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
