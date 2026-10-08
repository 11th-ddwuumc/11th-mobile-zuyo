import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/models/movie.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class RankedMovieCard extends StatelessWidget {
  const RankedMovieCard({
    super.key,
    required this.movie,
    required this.rank,
    required this.onTap,
  });

  final Movie movie;
  final int rank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: 140,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 포스터
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(movie.posterAsset, fit: BoxFit.cover),
                  ),

                  // 순위
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 24,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xCC000000),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0x33FFFFFF)),
                      ),
                      child: Text(
                        '$rank',
                        style: AppTextStyles.labelSmallBold.copyWith(
                          fontSize: 12,
                          color: AppColors.lowest,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 영화 제목
            Text(
              movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              strutStyle: const StrutStyle(
                fontSize: 16,
                height: 1.5,
                forceStrutHeight: true,
              ),
              style: AppTextStyles.bodyLargeMedium.copyWith(
                color: AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 4),

            // 별점 
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/star_filled.svg',
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    AppColors.tertiary300,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
                
                Text(
                  (movie.rating * 2).toStringAsFixed(1),
                  strutStyle: const StrutStyle(
                    fontSize: 12,
                    height: 16 / 12,
                    forceStrutHeight: true,
                  ),
                  style: AppTextStyles.labelSmallRegular.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
