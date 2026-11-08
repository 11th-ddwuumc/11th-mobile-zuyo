import 'package:flutter/material.dart';
import 'package:movielog/models/rating_with_movie.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';
import 'package:movielog/widgets/tmdb_poster_image.dart';

class MyRatingCard extends StatelessWidget {
  const MyRatingCard({
    super.key,
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  final RatingWithMovie entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

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
              width: 76,
              height: 114,
            ),
          ),
          const SizedBox(width: 14),
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
                  const SizedBox(height: 12),
                  Text(
                    rating.comment?.trim().isNotEmpty == true
                        ? rating.comment!
                        : movie == null
                        ? '포스터 정보 없음'
                        : '코멘트 없음',
                    style: AppTextStyles.bodyMediumRegular.copyWith(
                      fontSize: 13,
                      color: const Color(0xFF655F6C),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                _actionButton(
                  '수정',
                  onEdit,
                  AppColors.primary500,
                  const Color(0xFFF0EAF8),
                ),
                const SizedBox(height: 8),
                _actionButton(
                  '삭제',
                  onDelete,
                  AppColors.error,
                  const Color(0xFFFFF2F1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    String label,
    VoidCallback onPressed,
    Color foreground,
    Color background,
  ) {
    return SizedBox(
      width: 58,
      height: 34,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: foreground,
          backgroundColor: background,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        child: Text(label),
      ),
    );
  }
}
