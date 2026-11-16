import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/widgets/movielog_button.dart';
import 'package:movielog/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    'FLUTTER 8주차',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 64),
                  SvgPicture.asset(
                    'assets/logos/movielog_logo.svg',
                    width: 84,
                    height: 84,
                  ),
                  const SizedBox(height: 36),
                  Text(
                    '영화의 순간을\n기록하세요',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '보고 싶은 영화부터 나만의 평점까지\n한곳에서 관리해요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.7,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              // 1주차 StartScreen 하단의 '시작하기' ElevatedButton 자리를
              // 로딩/재시도 상태로 대체합니다.
              if (onRetry == null)
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.primary500,
                  ),
                )
              else
                Column(
                  children: [
                    Text(
                      message ?? '로그인 상태를 확인하지 못했어요.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: MovieLogButton(label: '다시 시도', onPressed: onRetry),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
