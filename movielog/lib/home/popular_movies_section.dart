import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/home/ranked_movie_card.dart';
import 'package:movielog/movie/movie.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class PopularMoviesSection extends StatelessWidget {
  const PopularMoviesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final popularMovies = [
      for (final id in [7, 8, 9])
        if (findMovieById(id) case final Movie movie) movie,
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '인기 영화',
                  style: AppTextStyles.titleMediumMedium.copyWith(
                    fontSize: 20,
                    height: 28 / 20,
                    color: AppColors.neutral900,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/movies'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary600,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('전체보기'),
                      SvgPicture.asset(
                        'assets/icons/chevron_right.svg',
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary600,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 인기영화 카드 
          const SizedBox(height: 16),
          SizedBox(
            // 포스터 200 + 간격 12 + 제목 24 + 간격 4 + 평점 16 = 256.
            height: 256,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: popularMovies.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final movie = popularMovies[index];
                return RankedMovieCard(
                  movie: movie,
                  rank: index + 1,
                  onTap: () => context.push('/movies/${movie.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
