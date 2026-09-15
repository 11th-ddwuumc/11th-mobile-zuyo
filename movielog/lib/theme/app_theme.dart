import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,

    // 폰트 설정
    fontFamily: 'Manrope',

    // 기본 색상 설정
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary500,
      primary: AppColors.primary500,
      onPrimary: AppColors.neutral100,
      surface: AppColors.base,
      onSurface: AppColors.neutral900,
    ),

    // 기본 텍스트 설정
    textTheme: TextTheme(
      titleLarge: AppTextStyles.titleLargeBold,
      titleMedium: AppTextStyles.titleMediumSemiBold,
      bodyLarge: AppTextStyles.bodyLargeRegular,
      bodyMedium: AppTextStyles.bodyMediumRegular,
      labelLarge: AppTextStyles.labelLargeSemiBold,
      labelSmall: AppTextStyles.labelSmallRegular,
    ),

    // 배경색
    scaffoldBackgroundColor: AppColors.base,

    // 상단 바
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.base,
      foregroundColor: AppColors.primary500,
      titleTextStyle: AppTextStyles.titleMediumMedium,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
  );
}