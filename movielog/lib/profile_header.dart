import 'package:flutter/material.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget{
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,

      children: [
        // 프로필 이미지
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary300,
              width: 2,
            ),
          ),
          child: const CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(
              'assets/images/profile/profile_movielog.jpg',
            ),
          ),
        ),

        // 닉네임 및 소개
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Text(
              '무비러버',
              style: AppTextStyles.titleMediumMedium.copyWith(
                  fontSize: 22,
                  height: 28 / 22,
                  color: AppColors.neutral900,
                  fontWeight: FontWeight.bold
              ),
            ),

            Text(
                '매주 주말엔 영화관으로 출근하는 프로 관람객. 좋은 영화를 보고 기록하는 것을 좋아합니다.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLargeMedium.copyWith(
                  letterSpacing: 0,
                  color: Color(0xFF494551),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis
            ),
          ],
        ),

        // 버튼
        Container(
          padding: const EdgeInsets.only(top:8),
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary500,
              side: const BorderSide(
                color: AppColors.primary500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              textStyle: AppTextStyles.bodyLargeMedium.copyWith(
                letterSpacing: 0,
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('프로필 수정'),
          ),
        )
      ],
    );
  }
}
