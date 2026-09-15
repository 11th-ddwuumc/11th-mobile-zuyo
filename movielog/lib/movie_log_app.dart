import 'package:flutter/material.dart';
import 'package:movielog/theme/app_theme.dart';
import 'profile/profile_screen.dart';

class MovieLogApp extends StatelessWidget{
  const MovieLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // 앱 전체 설정
      debugShowCheckedModeBanner: false,
      title: 'MovieLog',
      theme: AppTheme.light,
      home: const ProfileScreen(),
    );
  }
}