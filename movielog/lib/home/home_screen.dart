import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/common_app_bar.dart';
import 'package:movielog/home/featured_movie_card.dart';
import 'package:movielog/movie/movie.dart';
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 인사
              Padding(
                padding: EdgeInsetsGeometry.all(16),
                child: Text(
                  '오늘은 어떤\n영화를 볼까요?',
                  style: AppTextStyles.titleLargeMedium.copyWith(
                    color: AppColors.textPrimary
                  ),
                )
              ),
              
              // 추천카드 
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 24,
                ),
                child: FeaturedMovieCard(
                  movie: movies.first,
                  onTap: () => context.push('/movies/${movies.first.id}'),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
