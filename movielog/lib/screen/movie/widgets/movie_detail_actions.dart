import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class MovieDetailActions extends StatelessWidget {
  const MovieDetailActions({super.key, required this.onRate});

  final VoidCallback onRate;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onRate,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.lowest,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/rate_comment.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.lowest,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '평점 남기기',
            style: AppTextStyles.labelLargeMedium.copyWith(
              color: AppColors.lowest,
            ),
          ),
        ],
      ),
    );
  }
}
