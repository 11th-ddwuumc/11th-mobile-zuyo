import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/view_models/movie_list_view_model.dart';
import 'package:movielog/widgets/common_app_bar.dart';
import 'package:movielog/screen/movie/widgets/movie_genre_filter.dart';
import 'package:movielog/screen/movie/widgets/movie_grid.dart';
import 'package:movielog/services/genre_preference.dart';
import 'package:movielog/screen/movie/states/movie_list_empty.dart';
import 'package:movielog/screen/movie/states/movie_list_error.dart';
import 'package:movielog/screen/movie/states/movie_list_loading.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:provider/provider.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {

  final genrePreference = GenrePreference();

  @override
  void initState() {
    super.initState();
  }

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
              Consumer<MovieListViewModel>(
                builder: (context, viewModel, child){
                  return MovieGenreFilter(
                    genres: viewModel.genres,
                    selectedGenre: viewModel.selectedGenreId,
                    isLoading: viewModel.status == MovieListLoadStatus.loading,
                    onSelected: (genreId) => viewModel.selectGenre(genreId),
                  );
                }
              ),
              
              const SizedBox(height: 16),
              // 영화 목록 그리드 
              Expanded(
                child: Consumer<MovieListViewModel>(
                  builder: (context, viewModel, child) {
                    return switch (viewModel.status) {
                      MovieListLoadStatus.idle ||
                      MovieListLoadStatus.loading => const MovieListLoading(),
                    
                      MovieListLoadStatus.error => MovieListError(
                        onRetry: () {
                          if (viewModel.selectedGenreId == null) {
                            viewModel.loadInitial();
                          } else {
                            viewModel.selectGenre(viewModel.selectedGenreId);
                          }
                        },
                      ),

                      MovieListLoadStatus.empty => const MovieListEmpty(),
                    
                      MovieListLoadStatus.success => MovieGrid(
                        movies: viewModel.movies,
                        genreNamesFor: viewModel.genreNamesFor,
                      ),
                    };
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
