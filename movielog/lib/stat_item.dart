import 'package:flutter/material.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class StatItem extends StatelessWidget {
  const StatItem({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.low,
        border: Border.all(color: AppColors.primary200, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: AppTextStyles.labelLargeMedium.copyWith(
                color: Color(0xFF494551),
              )
            ),
          ),
          Text(
            value,
            style: AppTextStyles.titleLargeBold.copyWith(
              color: AppColors.primary500,
            ),
          ),
        ],
      ),
    );
  }
}