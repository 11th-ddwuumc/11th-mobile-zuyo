import 'package:flutter/material.dart';
import 'package:movielog/models/tmdb_genre_dto.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';

class MovieGenreFilter extends StatelessWidget {
  const MovieGenreFilter({
    super.key,
    required this.genres,
    required this.selectedGenre,
    required this.onSelected,
    required this.isLoading,
  });

  final List<TmdbGenreDto> genres;
  final int? selectedGenre;
  final ValueChanged<int?> onSelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: genres.length+1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final genre = index == 0 ? null : genres[index - 1];
          final genreId = genre?.id;
          final isSelected = genreId == selectedGenre;

          return Center(
            child: ChoiceChip(
              label: Text(genre?.name ?? '전체'),
              padding: EdgeInsets.zero,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              selected: isSelected,
              onSelected: isLoading ? null : (_) => onSelected(genreId),
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
