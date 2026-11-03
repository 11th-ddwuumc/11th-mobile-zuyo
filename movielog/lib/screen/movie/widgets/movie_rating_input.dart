import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/theme/app_colors.dart';

class MovieRatingInput extends StatelessWidget {
  const MovieRatingInput({
    super.key,
    required this.rating,
    required this.onChanged,
  });

  final double rating;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating,
      minRating: 0.5,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 40,
      itemBuilder: (context, index) {
        return SvgPicture.asset(
          'assets/icons/star_filled.svg',
          colorFilter: ColorFilter.mode(AppColors.primary500, BlendMode.srcIn),
        );
      },
      onRatingUpdate: onChanged,
    );
  }
}