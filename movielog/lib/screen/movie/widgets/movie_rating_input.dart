import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/theme/app_colors.dart';

class MovieRatingInput extends StatelessWidget {
  const MovieRatingInput({
    super.key,
    required this.rating,
    required this.onChanged,
    this.enabled = true,
  });

  final double rating;
  final ValueChanged<double> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: rating,
      minRating: 1,
      allowHalfRating: false,
      ignoreGestures: !enabled,
      itemCount: 5,
      itemSize: 40,
      ratingWidget: RatingWidget(
        full: SvgPicture.asset(
          'assets/icons/star_filled.svg',
          colorFilter: const ColorFilter.mode(
            AppColors.primary500,
            BlendMode.srcIn,
          ),
        ),
        half: const Icon(Icons.star_half, color: AppColors.primary500),
        empty: const Icon(Icons.star_border, color: AppColors.primary500),
      ),
      onRatingUpdate: onChanged,
    );
  }
}
