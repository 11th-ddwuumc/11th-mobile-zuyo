import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/common_app_bar.dart';
import 'package:movielog/movie/movie.dart';
import 'package:movielog/movie/movie_detail_actions.dart';
import 'package:movielog/movie/movie_detail_info.dart';
import 'package:movielog/movie/movie_synopsis.dart';
import 'package:movielog/theme/app_colors.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context) {
    final movie = findMovieById(int.tryParse(movieId));

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Cinema Archive',
        actions: [
          IconButton(
            onPressed: () {
              // todo: 나중에 구현
            },
            icon: SvgPicture.asset(
              'assets/icons/share.svg',
              width: 18,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      body: movie == null
          ? const Center(child: Text('영화를 찾을 수 없습니다.'))
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 영화 포스터
                    AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Image.asset(movie.posterAsset, fit: BoxFit.cover),
                    ),

                    // 정보
                    MovieDetailInfo(movie: movie),
                    
                    // 시놉시스
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFCBC4D2),
                    ),
                    MovieSynopsis(synopsis: movie.synopsis),
                  ],
                ),
              ),
            ),
      
      // 버튼 
      bottomNavigationBar: movie == null ? null : Container(
        decoration: const BoxDecoration(
          color: AppColors.base,
          border: Border(
            top: BorderSide(
              color: AppColors.highest,
              width: 1,
            ),
          ),
        ),
        child: const SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: MovieDetailActions(),
          ),
        ),
      ),
    );
  }
}
