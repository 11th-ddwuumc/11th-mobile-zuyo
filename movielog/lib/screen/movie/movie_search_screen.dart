import 'package:flutter/material.dart';
import 'package:movielog/models/tmdb_movie_dto.dart';
import 'package:movielog/screen/movie/widgets/movie_card.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';
import 'package:movielog/view_models/load_phase.dart';
import 'package:movielog/view_models/page_movies_view_model.dart';
import 'package:movielog/widgets/common_app_bar.dart';
import 'package:movielog/widgets/movie_page_footer.dart';
import 'package:movielog/widgets/movielog_button.dart';
import 'package:provider/provider.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key, required this.onOpenMovie});

  final Future<void> Function(TmdbMovieDto movie) onOpenMovie;

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final _text = TextEditingController();
  String _submittedQuery = '';
  String? _inputError;

  void _submitSearch(String value) {
    final query = value.trim();
    if (query.isEmpty) {
      setState(() => _inputError = '검색어를 입력해 주세요.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _inputError = null;
      _submittedQuery = query;
    });
    context.read<PagedMoviesViewModel>().loadInitial(query: query);
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PagedMoviesViewModel>();
    final statusStyle = AppTextStyles.bodyLargeBold.copyWith(
      color: AppColors.secondary500,
    );
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.secondary300),
    );

    return Scaffold(
      appBar: CommonAppBar(
        title: '영화 검색',
        centerTitle: true,
        titleStyle: AppTextStyles.titleLargeBold.copyWith(
          fontSize: 20,
          height: 28 / 20,
          color: AppColors.primary500,
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 0),
          child: Column(
            children: [
              TextField(
                controller: _text,
                textInputAction: TextInputAction.search,
                onSubmitted: _submitSearch,
                onChanged: (_) {
                  if (_inputError != null) setState(() => _inputError = null);
                },
                decoration: InputDecoration(
                  hintText: '검색어 입력',
                  errorText: _inputError,
                  filled: true,
                  fillColor: AppColors.lowest,
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: const BorderSide(color: AppColors.primary500),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TextButton(
                      onPressed: () => _submitSearch(_text.text),
                      child: const Text('검색'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: switch (vm.phase) {
                  LoadPhase.idle => const SizedBox.shrink(),
                  LoadPhase.loading => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  LoadPhase.empty => Align(
                    alignment: const Alignment(0, -0.25),
                    child: Text('검색 결과가 없습니다.', style: statusStyle),
                  ),
                  LoadPhase.error => Align(
                    alignment: const Alignment(0, -0.25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          vm.errorMessage ?? '검색 결과를 불러오지 못했습니다.',
                          style: statusStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        MovieLogButton(
                          width: 224,
                          label: '다시 시도',
                          onPressed: () =>
                              vm.loadInitial(query: _submittedQuery),
                        ),
                      ],
                    ),
                  ),
                  LoadPhase.ready => CustomScrollView(
                    key: ValueKey(_submittedQuery),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [
                      SliverList.separated(
                        itemCount: vm.movies.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final movie = vm.movies[index];
                          final releaseDate = movie.releaseDate;
                          return MovieCard.horizontal(
                            movie: movie,
                            caption:
                                releaseDate != null && releaseDate.length >= 4
                                ? releaseDate.substring(0, 4)
                                : '',
                            onTap: () => widget.onOpenMovie(movie),
                          );
                        },
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: MoviePageFooter(
                            vm: vm,
                            loadMoreLabel: '검색 결과 더 보기',
                            padding: const EdgeInsets.only(top: 24, bottom: 32),
                          ),
                        ),
                      ),
                    ],
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
