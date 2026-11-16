import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/models/tmdb_genre_dto.dart';
import 'package:movielog/services/tmdb_movie_service.dart';
import 'package:movielog/view_models/movie_detail_view_model.dart';
import 'package:movielog/view_models/signup_view_model.dart';
import 'package:movielog/widgets/common_app_bar.dart';
import 'package:movielog/screen/movie/widgets/movie_detail_actions.dart';
import 'package:movielog/screen/movie/widgets/movie_detail_info.dart';
import 'package:movielog/screen/movie/widgets/movie_synopsis.dart';
import 'package:movielog/screen/movie/widgets/rating_dialog.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/widgets/tmdb_poster_image.dart';
import 'package:provider/provider.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>{
  late final Future<List<TmdbGenreDto>> _genresFuture;

  @override
  void initState() {
    super.initState();
    _genresFuture = context.read<TmdbMovieService>().fetchGenres();
  }

  double? myRating;
  bool isBookmark = false;

  Future<void> _openRatingDialog() async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false, 
      builder: (_) => RatingDialog(
        onSubmit: (score, comment) async {
          final viewModel = context.read<MovieDetailViewModel>();
          await viewModel.createRating(score: score, comment: comment);
          if (viewModel.submitStatus != SubmitStatus.success) {
            throw StateError(viewModel.submitMessage ?? '저장에 실패했습니다.');
          }
        },
      ),
    );

    if (!mounted || saved != true) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('평점을 등록했습니다. 마이페이지에서 확인해 주세요.'),
      ),
    );
  }

  void _toggleBookmark() {
    setState(() {
      isBookmark = !isBookmark;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            isBookmark ? '즐겨찾기에 추가했어요.' : '즐겨찾기에서 해제했어요.',
          ),
        ),
      );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<MovieDetailViewModel>(
      builder: (context, viewModel, child) {
        final movie = viewModel.movie;
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 영화 포스터
                  AspectRatio(
                    aspectRatio: 3 / 4,
                    child: LayoutBuilder(
                      builder: (context, constraints){
                        return TmdbPosterImage(
                          posterPath: movie.posterPath, width: constraints.maxWidth, height: constraints.maxHeight
                        );
                      }
                    ),
                  ),

                  // 정보
                  FutureBuilder<List<TmdbGenreDto>>(
                    future: _genresFuture,
                    builder: (context, snapshot) {
                      final genreNames = (snapshot.data ?? const <TmdbGenreDto>[])
                          .where((genre) => movie.genreIds.contains(genre.id))
                          .map((genre) => genre.name)
                          .toList();
                      return MovieDetailInfo(movie: movie, genreNames: genreNames);
                    },
                  ),
                  
                  // 시놉시스
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFCBC4D2),
                  ),
                  MovieSynopsis(synopsis: movie.overview),
                ],
              ),
            ),
          ),
          
          // 버튼 
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: AppColors.base,
              border: Border(
                top: BorderSide(
                  color: AppColors.highest,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: MovieDetailActions(
                  onRate: _openRatingDialog,
                  onBookmark: _toggleBookmark,
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
