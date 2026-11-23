import 'package:flutter/material.dart';
import 'package:movielog/models/tmdb_movie_dto.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';
import 'package:movielog/widgets/tmdb_poster_image.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required TmdbMovieDto this.movie,
    required this.genreNames,
    required this.onTap,
  }) : _horizontalCaption = null,
       isRetrying = false,
       onRetry = null;

  const MovieCard.horizontal({
    super.key,
    required this.movie,
    required String caption,
    required this.onTap,
    this.onRetry,
    this.isRetrying = false,
  }) : genreNames = const [],
       _horizontalCaption = caption;

  final TmdbMovieDto? movie;
  final VoidCallback? onTap;
  final List<String> genreNames;

  final String? _horizontalCaption;
  final bool isRetrying;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final caption = _horizontalCaption;
    if (caption != null) {
      return _HorizontalMovieCard(
        movie: this.movie,
        caption: caption,
        onOpen: onTap,
        onRetry: onRetry,
        isRetrying: isRetrying,
      );
    }

    final movie = this.movie!;
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
                    builder: (context, constraints) {
                      return TmdbPosterImage(
                        posterPath: movie.posterPath,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      );
                    },
                  ),
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

class _HorizontalMovieCard extends StatelessWidget {
  const _HorizontalMovieCard({
    required this.movie,
    required this.caption,
    required this.isRetrying,
    required this.onRetry,
    required this.onOpen,
  });

  final TmdbMovieDto? movie;
  final String caption;
  final bool isRetrying;
  final VoidCallback? onRetry;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    final posterPath = movie?.posterPath;
    return Material(
      color: AppColors.base,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.secondary300),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: posterPath == null || posterPath.isEmpty
                    ? const SizedBox(
                        width: 80,
                        height: 120,
                        child: ColoredBox(color: AppColors.secondary200),
                      )
                    : TmdbPosterImage(
                        posterPath: posterPath,
                        width: 80,
                        height: 120,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie?.title ?? '영화 정보를 불러오지 못했어요.',
                        style: AppTextStyles.bodyLargeBold,
                      ),
                      if (caption.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          caption,
                          style: AppTextStyles.labelLargeBold.copyWith(
                            color: AppColors.primary500,
                          ),
                        ),
                      ],
                      if (movie == null)
                        TextButton(
                          onPressed: isRetrying ? null : onRetry,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                          ),
                          child: Text(isRetrying ? '불러오는 중…' : '정보 다시 불러오기'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
