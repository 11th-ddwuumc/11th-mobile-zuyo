import 'package:flutter/material.dart';
import 'package:movielog/router/app_router.dart';
import 'package:movielog/theme/app_theme.dart';

class MovieLogApp extends StatelessWidget{
  const MovieLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router( // 앱 전체 설정
      debugShowCheckedModeBanner: false,
      title: 'MovieLog',
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}