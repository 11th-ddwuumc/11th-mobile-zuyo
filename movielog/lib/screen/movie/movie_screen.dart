import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/view_models/load_phase.dart';
import 'package:movielog/view_models/page_movies_view_model.dart';
import 'package:movielog/widgets/common_app_bar.dart';
import 'package:movielog/widgets/movie_page_footer.dart';
import 'package:movielog/screen/movie/widgets/movie_genre_filter.dart';
import 'package:movielog/screen/movie/widgets/movie_grid.dart';
import 'package:movielog/screen/movie/states/movie_list_empty.dart';
import 'package:movielog/screen/movie/states/movie_list_error.dart';
import 'package:movielog/screen/movie/states/movie_list_loading.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:provider/provider.dart';

class MovieScreen extends StatelessWidget {
  const MovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              Consumer<PagedMoviesViewModel>(
                builder: (context, viewModel, child) {
                  return MovieGenreFilter(
                    genres: viewModel.genres,
                    selectedGenre: viewModel.selectedGenreId,
                    isLoading:
                        viewModel.phase == LoadPhase.loading &&
                        viewModel.genres.isEmpty,
                    onSelected: (genreId) {
                      if (genreId != viewModel.selectedGenreId) {
                        viewModel.loadInitial(genreId: genreId);
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 16),
              // 영화 목록 그리드
              Expanded(
                child: Consumer<PagedMoviesViewModel>(
                  builder: (context, viewModel, child) {
                    return switch (viewModel.phase) {
                      LoadPhase.idle ||
                      LoadPhase.loading => const MovieListLoading(),

                      LoadPhase.error => MovieListError(
                        onRetry: () => viewModel.loadInitial(
                          genreId: viewModel.selectedGenreId,
                        ),
                      ),

                      LoadPhase.empty => const MovieListEmpty(),

                      LoadPhase.ready => MovieGrid(
                        key: ValueKey(viewModel.selectedGenreId),
                        movies: viewModel.movies,
                        genreNamesFor: viewModel.genreNamesFor,
                        footer: MoviePageFooter(vm: viewModel),
                      ),
                    };
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
