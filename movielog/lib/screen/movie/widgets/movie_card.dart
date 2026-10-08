import 'package:flutter/material.dart';
import 'package:movielog/models/tmdb_movie_dto.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';
import 'package:movielog/widgets/tmdb_poster_image.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key, 
    required this.movie, 
    required this.genreNames,
    required this.onTap
  });

  final TmdbMovieDto movie;
  final VoidCallback onTap;
  final List<String> genreNames;

  @override
  Widget build(BuildContext context) {
    final releaseDate = movie.releaseDate;
    final year = releaseDate != null && releaseDate.length >= 4
      ? releaseDate.substring(0, 4)
      : '개봉일 미정';

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 포스터 + 오른쪽 위 평점
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LayoutBuilder(
                    builder: (context, constraints){
                      return TmdbPosterImage(
                        posterPath: movie.posterPath, width: constraints.maxWidth, height: constraints.maxHeight
                      );
                    }
                  )
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xCC322F35),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '★ ${(movie.voteAverage / 2).toStringAsFixed(1)}',
                          style: AppTextStyles.labelSmallBold.copyWith(
                            color: Color(0xFFF5EFF7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 제목 + 정보
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
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

                // 정보
                Text(
                  [
                    year,
                    if (genreNames.isNotEmpty) genreNames.first,
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  strutStyle: const StrutStyle(
                    fontSize: 16,
                    height: 1.5,
                    forceStrutHeight: true,
                  ),
                  style: AppTextStyles.bodyLargeRegular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
