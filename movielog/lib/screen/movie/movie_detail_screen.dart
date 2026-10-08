import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movielog/models/tmdb_movie_dto.dart';
import 'package:movielog/widgets/common_app_bar.dart';
import 'package:movielog/screen/movie/widgets/movie_detail_actions.dart';
import 'package:movielog/screen/movie/widgets/movie_detail_info.dart';
import 'package:movielog/screen/movie/widgets/movie_synopsis.dart';
import 'package:movielog/screen/movie/widgets/rating_dialog.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/widgets/tmdb_poster_image.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.movie});

  final TmdbMovieDto movie;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>{
  double? myRating;
  bool isBookmark = false;

  Future<void> _openRatingDialog() async {
    final result = await showDialog<double>(
      context: context,
      builder: (context) => RatingDialog(movieId: widget.movie.id),
    );

    if (result == null || !mounted) return;

    setState(() {
      myRating = result;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('평점 ${result.toStringAsFixed(1)}점을 남겼어요.')),
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
    final movie = widget.movie;

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
              MovieDetailInfo(movie: movie),
              
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
}
