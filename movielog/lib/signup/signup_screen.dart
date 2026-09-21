import 'package:flutter/material.dart';
import 'package:movielog/common_app_bar.dart';

class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>{
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 32,
              children: [
                // 환영 문구
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: const Text(
                    '환영합니다!\n간단한 정보만 입력하고 시작해보세요.',
                    textAlign: TextAlign.center,
                  ),
                ),

                // 입력창

                // 버튼
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }
}