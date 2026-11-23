import 'package:flutter/material.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/view_models/favorite_detail_view_model.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});

  Future<void> _onPressed(
    BuildContext context,
    FavoriteDetailViewModel viewModel,
  ) async {
    if (viewModel.isBusy || !viewModel.isCurrent) return;
    final retrying = viewModel.isFavorite == null;
    if (retrying) {
      await viewModel.load();
    } else {
      await viewModel.toggle();
    }
    if (!context.mounted || !viewModel.isCurrent) return;

    final message =
        viewModel.errorMessage ??
        (retrying
            ? null
            : viewModel.isFavorite == true
            ? '즐겨찾기에 추가했어요.'
            : '즐겨찾기에서 해제했어요.');
    if (message == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FavoriteDetailViewModel>();
    final isFavorite = viewModel.isFavorite;
    return SizedBox.square(
      dimension: 48,
      child: viewModel.isBusy
          ? const Center(
              child: SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : IconButton(
              color: AppColors.primary500,
              tooltip: switch (isFavorite) {
                true => '즐겨찾기 해제',
                false => '즐겨찾기 추가',
                null => '즐겨찾기 조회 다시 시도',
              },
              onPressed: () => _onPressed(context, viewModel),
              icon: Icon(switch (isFavorite) {
                true => Icons.bookmark,
                false => Icons.bookmark_border,
                null => Icons.refresh,
              }),
            ),
    );
  }
}
