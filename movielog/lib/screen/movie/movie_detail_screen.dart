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
    final viewModel = context.read<MovieDetailViewModel>();
    final currentRating = viewModel.rating;
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false, 
      builder: (_) => RatingDialog(
        initialScore: currentRating?.score ?? 0,
        initialComment: currentRating?.comment,
        onSubmit: (score, comment) async {
          if (currentRating == null) {
            await viewModel.createRating(score: score, comment: comment);
          } else {
            await viewModel.updateRating(score: score, comment: comment);
          }
          if (viewModel.submitStatus != SubmitStatus.success) {
            throw StateError(viewModel.submitMessage ?? '저장에 실패했습니다.');
          }
        },
      ),
    );

    if (!mounted || saved != true) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          currentRating == null ? '평점이 등록됐습니다.' : '평점이 수정됐습니다.',
        ),
      ),
    );
  }

  Future<void> _deleteRating() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('평점을 삭제할까요?'),
        content: const Text('삭제한 평점은 되돌릴 수 없어요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    final viewModel = context.read<MovieDetailViewModel>();
    await viewModel.deleteRating();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          viewModel.submitStatus == SubmitStatus.success
              ? '평점을 삭제했어요.'
              : viewModel.submitMessage ?? '평점을 삭제하지 못했어요.',
        ),
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
                  if (viewModel.rating case final rating?)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('내 평점'),
                          const SizedBox(height: 8),
                          Text('★ ${rating.score} / 5'),
                          if (rating.comment?.isNotEmpty == true) ...[
                            const SizedBox(height: 8),
                            Text(rating.comment!),
                          ],
                          TextButton(
                            onPressed: viewModel.submitStatus == SubmitStatus.submitting
                                ? null
                                : _deleteRating,
                            child: const Text('평점 삭제'),
                          ),
                        ],
                      ),
                    ),
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
