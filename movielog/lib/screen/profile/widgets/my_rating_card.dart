import 'package:flutter/material.dart';
import 'package:movielog/models/rating_with_movie.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';
import 'package:movielog/widgets/tmdb_poster_image.dart';

class MyRatingCard extends StatelessWidget {
  const MyRatingCard({super.key, required this.entry});

  final RatingWithMovie entry;

  @override
  Widget build(BuildContext context) {
    final rating = entry.rating;
    final movie = entry.movie;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lowest,
        border: Border.all(color: const Color(0xFFD9D3E1), width: 2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: TmdbPosterImage(
              posterPath: movie?.posterPath,
              width: 86,
              height: 130,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie?.title ?? '영화 #${rating.movieId}',
                    style: AppTextStyles.bodyLargeBold.copyWith(
                      color: const Color(0xFF25232A),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '별점 ${rating.score} / 5',
                    style: AppTextStyles.bodyMediumBold.copyWith(
                      color: AppColors.primary500,
                    ),
                  ),
                  if (rating.comment != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      rating.comment!,
                      style: AppTextStyles.bodyMediumRegular.copyWith(
                        fontSize: 13,
                        color: const Color(0xFF655F6C),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
