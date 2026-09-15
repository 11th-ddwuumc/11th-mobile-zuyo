import 'package:flutter/material.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class FavoriteGenres extends StatelessWidget{
  const FavoriteGenres({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(
          '선호하는 장르',
          style: AppTextStyles.bodyLargeBold,
        ),
        Row(
          spacing: 8,
          children: [
            GenreChip(label: '드라마'),
            GenreChip(label: 'SF'),
            GenreChip(label: '애니메이션'),
          ],
        )
      ],
    );
  }
}

class GenreChip extends StatelessWidget {
  const GenreChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      labelStyle: AppTextStyles.labelLargeMedium.copyWith(
        fontSize: 12,
        height: 16 / 12,
        color: AppColors.primary600,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: BorderSide.none,
      backgroundColor: AppColors.primary200,
      shape: const StadiumBorder(),
    );
  }
}
