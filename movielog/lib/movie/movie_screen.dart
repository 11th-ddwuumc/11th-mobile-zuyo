import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/common_app_bar.dart';
import 'package:movielog/movie/movie.dart';
import 'package:movielog/movie/movie_genre_filter.dart';
import 'package:movielog/movie/movie_grid.dart';
import 'package:movielog/movie/services/fake_movie_service.dart';
import 'package:movielog/movie/states/movie_list_empty.dart';
import 'package:movielog/movie/states/movie_list_error.dart';
import 'package:movielog/movie/states/movie_list_loading.dart';
import 'package:movielog/theme/app_colors.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  String selectedGenre = '전체';
  final genres = ['전체', ...movies.expand((movie) => movie.genres).toSet()];

  late Future<List<Movie>> _moviesFuture;

  final FakeMovieService movieService = const FakeMovieService();

  void _retry() {
    setState(() {
      _moviesFuture = movieService.fetchMovies();
    });
  }

  @override
  void initState() {
    super.initState();
    _moviesFuture = movieService.fetchMovies();
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

              // 영화 목록 그리드 
              Expanded(
                child: FutureBuilder<List<Movie>>(
                  future: _moviesFuture, 
                  builder: (context, snapshot){
        
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const MovieListLoading();
                    }
                    
                    if (snapshot.hasError) {
                      return MovieListError(onRetry: _retry);
                    }

                    final movies = snapshot.data ?? const <Movie>[];
                    
                    final filteredMovies = selectedGenre == '전체' 
                      ? movies 
                      : movies
                      .where((movie) => movie.genres.contains(selectedGenre)).toList();
                    
                    if (filteredMovies.isEmpty) {
                      return const MovieListEmpty();
                    }
                    
                    return MovieGrid(movies: filteredMovies);
                  }
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
