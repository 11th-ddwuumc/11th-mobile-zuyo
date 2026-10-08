import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/common_app_bar.dart';
import 'package:movielog/movie/movie.dart';
import 'package:movielog/movie/movie_card.dart';
import 'package:movielog/movie/movie_genre_filter.dart';
import 'package:movielog/theme/app_colors.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  String selectedGenre = '전체';
  final genres = ['전체', ...movies.expand((movie) => movie.genres).toSet()];

  @override
  Widget build(BuildContext context) {
    final List<Movie> filteredMovies;
    
    if (selectedGenre == '전체') {
      filteredMovies = movies;
    } else {
      filteredMovies = movies
        .where((movie) => movie.genres.contains(selectedGenre))
        .toList();
    }

    return Scaffold(
      appBar: CommonAppBar(
        title: '영화',
        actions: [
          IconButton(
            onPressed: () {
              // todo: 나중에
            },
            icon: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
          child: Column(
            children: [
              // 장르 필터
              MovieGenreFilter(
                genres: genres,
                selectedGenre: selectedGenre,
                onSelected: (genre) {
                  setState(() {
                    selectedGenre = genre;
                  });
                },
              ),
              const SizedBox(height: 16),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const columnSpacing = 16.0; // 옆 카드와의 간격
                    final cardWidth = (constraints.maxWidth - columnSpacing) / 2;
                    
                    // 포스터 2:3 + 간격 4(포스터랑 제목) + 위 패딩 8(제목 위의) + 텍스트 두 줄
                    final posterHeight = cardWidth * 1.5; // 포스터 비율 2:3
                    final infoHeight = 8.0 + 24.0 + 24.0;
                    final cardHeight = posterHeight + 4.0 + infoHeight;

                    // 영화 카드
                    return GridView.builder(
                      padding: EdgeInsets.only(bottom: 16),
                      itemCount: filteredMovies.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: columnSpacing,
                        mainAxisSpacing: 24, // 밑의 카드와의 간격
                        mainAxisExtent: cardHeight,
                      ),
                      itemBuilder: (context, index) {
                        final movie = filteredMovies[index];
                        return MovieCard(
                          movie: movie,
                          onTap: () => context.push('/movies/${movie.id}'),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
