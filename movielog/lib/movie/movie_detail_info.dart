import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movielog/movie/movie.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class MovieDetailInfo extends StatelessWidget{
  const MovieDetailInfo({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 16, right: 16, top:24, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          // 제목
          Text(
            movie.title,
            style: AppTextStyles.titleLargeMedium.copyWith(
              color: AppColors.neutral900,
            ),
          ),

          // 정보
          Text(
            [
              '${movie.year}',
              movie.genres.join('/'),
              if (movie.runtimeMinutes != null)
                '${movie.runtimeMinutes}분',
            ].join(' · '),
            style: AppTextStyles.bodyMediumRegular.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          // 별점
          const SizedBox(height: 12),
          Row(
            spacing: 4,
            children: [
              RatingBarIndicator(
                rating: 4.5,
                itemCount: 5,
                itemSize: 20,
                itemBuilder: (context, index) => SvgPicture.asset(
                  'assets/icons/star_filled.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary500,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              Text(
                '4.5',
                style: AppTextStyles.bodyLargeMedium.copyWith(
                  color: AppColors.neutral900
                ),
              ),

              Text(
                '(1,245)',
                style: AppTextStyles.labelLargeRegular.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          // 장르 Chip
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final label in [...movie.genres, ...movie.tags])
                Chip(
                  label: Text(label),
                  labelStyle: AppTextStyles.labelLargeMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  backgroundColor: AppColors.highest,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
            ],
          ),
        ],
      ),
    );
  }
}