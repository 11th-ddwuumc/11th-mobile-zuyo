import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/models/movie.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class FeaturedMovieCard extends StatelessWidget {
  const FeaturedMovieCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 356 / 534,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(movie.posterAsset, fit: BoxFit.cover),
              const ColoredBox(color: Color(0xB2000000)),
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    // 추천 신작 Chip
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 9.5, 12, 6.5),
                      decoration: BoxDecoration(
                        color: AppColors.primary600,
                        border: Border.all(color: AppColors.primary400),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Text(
                        '추천 신작',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 16 / 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 영화 제목
                    Text(
                      movie.title,
                      style: AppTextStyles.titleLargeMedium.copyWith(
                        color: AppColors.lowest,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // 영화 장르 및 러닝타임
                    Text(
                      [
                        ...movie.genres,
                        if (movie.runtimeMinutes != null)
                          '${movie.runtimeMinutes}분',
                      ].join(' · '),
                      style: AppTextStyles.bodyLargeRegular.copyWith(
                        color: AppColors.lowest,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Button - 상세보기
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary600,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          minimumSize: const Size(0, 44),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: const StadiumBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/info.svg',
                              width: 18,
                              height: 18,
                              colorFilter: const ColorFilter.mode(
                                AppColors.lowest,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '상세보기',
                              style: AppTextStyles.bodyLargeMedium.copyWith(
                                color: AppColors.lowest,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
