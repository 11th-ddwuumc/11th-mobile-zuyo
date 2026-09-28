import 'package:flutter/material.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class MovieSynopsis extends StatelessWidget {
  const MovieSynopsis({
    super.key,
    required this.synopsis,
  });

  final String synopsis;

  @override
  Widget build(BuildContext context) {
    final paragraphs = synopsis.split('\n\n');

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '시놉시스',
            style: AppTextStyles.titleMediumMedium.copyWith(
              fontSize: 22,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 26,
            children: [
              for (final paragraph in paragraphs)
                Text(
                  paragraph,
                  style: AppTextStyles.bodyLargeMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}