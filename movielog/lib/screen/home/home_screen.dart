import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/widgets/common_app_bar.dart';
import 'package:movielog/screen/home/widgets/featured_movie_card.dart';
import 'package:movielog/screen/home/widgets/popular_movies_section.dart';
import 'package:movielog/view_models/movie_home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:movielog/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'MovieLog',
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: '검색',
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.primary500,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<MovieHomeViewModel>(
          builder: (context, viewModel, child) {
            switch (viewModel.status) {
              case MovieHomeLoadStatus.idle:
              case MovieHomeLoadStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case MovieHomeLoadStatus.error:
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(viewModel.message ?? '인기 영화를 불러오지 못했어요.'),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: viewModel.loadPopular,
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                );
              case MovieHomeLoadStatus.empty:
                return const Center(child: Text('인기 영화가 없습니다.'));
              case MovieHomeLoadStatus.success:
                final movies = viewModel.popularMovies;
                if (movies.isEmpty) {
                  return const Center(child: Text('인기 영화가 없습니다.'));
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 인사
                      Padding(
                        padding: EdgeInsetsGeometry.all(16),
                        child: Text(
                          '오늘은 어떤\n영화를 볼까요?',
                          style: AppTextStyles.titleLargeMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
        
                      // 추천카드
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                        child: FeaturedMovieCard(
                          movie: movies.first,
                          onTap: () => context.push('/movies/${movies.first.id}', extra: movies.first),
                        ),
                      ),
                      PopularMoviesSection(popularMovies: movies),
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
