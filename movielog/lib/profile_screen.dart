import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:movielog/profile_header.dart';
import 'package:movielog/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16, right: 16, top: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeader(),
              // todo: 통계 장르 추가
            ],
          ),
        ),
      ),
    );
  }
}


@Preview(name: '프로필 화면', size: Size(390, 844))
Widget profileScreenPreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const ProfileScreen(),
  );
}