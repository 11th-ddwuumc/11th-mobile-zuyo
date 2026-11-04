import 'package:flutter/material.dart';
import 'package:movielog/screen/profile/widgets/my_rating_card.dart';
import 'package:movielog/view_models/my_rating_view_model.dart';
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
                          viewModel.message ?? '평점을 불러오지 못했습니다.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        MovieLogButton(
                          label: '다시 시도',
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
                        if (index > 0) const SizedBox(height: 18),
                        MyRatingCard(entry: viewModel.ratings[index]),
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
}
