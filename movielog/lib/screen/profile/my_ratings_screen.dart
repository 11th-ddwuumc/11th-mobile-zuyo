import 'package:flutter/material.dart';
import 'package:movielog/models/rating_dto.dart';
import 'package:movielog/screen/profile/widgets/delete_rating_dialog.dart';
import 'package:movielog/screen/movie/widgets/rating_dialog.dart';
import 'package:movielog/screen/profile/widgets/my_rating_card.dart';
import 'package:movielog/view_models/my_ratings_view_model.dart';
import 'package:movielog/widgets/common_app_bar.dart';
import 'package:movielog/widgets/movielog_button.dart';
import 'package:provider/provider.dart';

class MyRatingsScreen extends StatelessWidget {
  const MyRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: '내가 등록한 평점', centerTitle: true),
      body: SafeArea(
        child: Consumer<MyRatingsViewModel>(
          builder: (context, viewModel, child) {
            switch (viewModel.status) {
              case MyRatingsLoadStatus.idle:
              case MyRatingsLoadStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case MyRatingsLoadStatus.empty:
                return const Center(child: Text('등록된 평점이 없습니다.'));
              case MyRatingsLoadStatus.error:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          viewModel.refreshWarning ??
                              viewModel.message ??
                              '평점을 불러오지 못했습니다.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        MovieLogButton(
                          label: viewModel.refreshWarning != null
                              ? '목록 다시 불러오기'
                              : '다시 시도',
                          onPressed: viewModel.load,
                        ),
                      ],
                    ),
                  ),
                );
              case MyRatingsLoadStatus.success:
                return RefreshIndicator(
                  onRefresh: viewModel.load,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
                    children: [
                      if (viewModel.message != null) ...[
                        Text(viewModel.message!),
                        const SizedBox(height: 18),
                      ],
                      for (
                        var index = 0;
                        index < viewModel.ratings.length;
                        index++
                      ) ...[
                        if (index > 0) const SizedBox(height: 16),
                        MyRatingCard(
                          entry: viewModel.ratings[index],
                          onEdit: () => onEditPressed(
                            context,
                            viewModel.ratings[index].rating,
                          ),
                          onDelete: () => onDeletePressed(
                            context,
                            viewModel.ratings[index].rating,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }

  Future<void> onEditPressed(
    BuildContext context,
    RatingDto rating,
  ) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RatingDialog(
        initialScore: rating.score,
        initialComment: rating.comment,
        onSubmit: (score, comment) =>
            context.read<MyRatingsViewModel>().updateRating(
              ratingId: rating.ratingId,
              score: score,
              comment: comment,
            ),
      ),
    );

    if (!context.mounted || saved != true) return;
  }

  Future<void> onDeletePressed(BuildContext context, RatingDto rating) async {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => DeleteRatingDialog(
        onConfirm: () => context.read<MyRatingsViewModel>().deleteRating(rating.ratingId),
      ),
    );
  }
}