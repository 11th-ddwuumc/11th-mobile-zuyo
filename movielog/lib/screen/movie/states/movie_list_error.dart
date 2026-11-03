import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movielog/theme/app_colors.dart';

class MovieListError extends StatelessWidget {
  const MovieListError({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/error.svg',
            width: 60,
            height: 60,
            colorFilter: ColorFilter.mode(AppColors.error, BlendMode.srcIn),
          ),
          const SizedBox(height: 12),
          const Text('영화를 불러오지 못했습니다.'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onRetry,
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}