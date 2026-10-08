import 'package:flutter/material.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class MovieGenreFilter extends StatelessWidget {
  const MovieGenreFilter({
    super.key,
    required this.genres,
    required this.selectedGenre,
    required this.onSelected,
  });

  final List<String> genres;
  final String selectedGenre;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: genres.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = genre == selectedGenre;

          return Center(
            child: ChoiceChip(
              label: Text(genre),
              padding: const EdgeInsets.symmetric(vertical: 8),
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              selected: isSelected,
              onSelected: (_) => onSelected(genre),
              showCheckmark: false,
              selectedColor: AppColors.primary500,
              backgroundColor: Color(0xFFE6E0E9),
              side: BorderSide.none,
              shape: const StadiumBorder(),
              visualDensity: VisualDensity.standard,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              labelStyle: AppTextStyles.labelSmallMedium.copyWith(
                color: isSelected ? AppColors.lowest : AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }
}
