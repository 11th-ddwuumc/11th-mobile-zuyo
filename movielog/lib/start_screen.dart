import 'package:flutter/material.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 홈에서 보여줄 시작 화면
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.base,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 64,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'FLUTTER 0주차',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 24),

                  SizedBox(
                    width: 128,
                    height: 128,
                    child: SvgPicture.asset(
                      'assets/logos/movielog_logo.svg',
                      width: 72,
                      height: 72,
                      semanticsLabel: 'MovieLog 로고',
                    )
                  ),

                  SizedBox(height: 32),

                  Text(
                    '영화의 순간을\n기록하세요',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.neutral900,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    '보고 싶은 영화부터 나만의 평점까지\n한곳에서 관리해요',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            // 버튼 
            Padding(
              padding: EdgeInsets.only(
                left: 32,
                right: 32,
                bottom: 56,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint('시작하기 버튼을 눌렀습니다.');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary600,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: Text('시작하기'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
