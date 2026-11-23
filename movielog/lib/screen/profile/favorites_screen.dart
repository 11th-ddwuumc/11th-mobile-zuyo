import 'package:flutter/material.dart';
import 'package:movielog/models/tmdb_movie_dto.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/theme/app_text_styles.dart';
import 'package:movielog/view_models/favorites_view_model.dart';
import 'package:movielog/view_models/load_phase.dart';
import 'package:movielog/widgets/common_app_bar.dart';
import 'package:movielog/screen/movie/widgets/movie_card.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key, required this.onOpenMovie});

  final Future<void> Function(TmdbMovieDto movie) onOpenMovie;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FavoritesViewModel>().refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.base,
    appBar: CommonAppBar(
      title: '내 즐겨찾기',
      titleStyle: AppTextStyles.titleLargeBold.copyWith(
        fontSize: 20,
        height: 28 / 20,
        color: AppColors.primary500,
      ),
      centerTitle: true,
    ),
    body: Consumer<FavoritesViewModel>(
      builder: (context, vm, _) {
        if (vm.phase == LoadPhase.idle || vm.phase == LoadPhase.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (vm.phase == LoadPhase.empty) {
          return Align(
            alignment: const Alignment(0, -0.25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.bookmark_border,
                  size: 34,
                  color: AppColors.primary500,
                ),
                const SizedBox(height: 32),
                Text('아직 즐겨찾기한 영화가 없습니다.', style: _statusStyle),
                const SizedBox(height: 12),
                const Text(
                  '영화 상세에서 북마크를 눌러보세요.',
                  style: TextStyle(color: AppColors.secondary500),
                ),
              ],
            ),
          );
        }

        if (vm.phase == LoadPhase.error) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('즐겨찾기를 불러오지 못했습니다.', style: _statusStyle),
                const SizedBox(height: 24),
                SizedBox(
                  width: 224,
                  child: FilledButton(
                    onPressed: vm.refresh,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 44),
                      backgroundColor: AppColors.primary500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('다시 시도'),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: vm.refresh,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: vm.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 18),
            itemBuilder: (context, index) {
              final item = vm.items[index], movie = item.movie;

              return MovieCard.horizontal(
                caption: '즐겨찾기한 영화',
                movie: movie,
                isRetrying: vm.isRetrying(item.favorite.movieId),
                onRetry: () => vm.retryMovie(item),
                onTap: movie == null
                    ? null
                    : () async {
                        await widget.onOpenMovie(movie);

                        if (!mounted) return;

                        await vm.refresh(); // ViewModel도 같은 현재 세션인지 다시 확인합니다.
                      },
              );
            },
          ),
        );
      },
    ),
  );
}

final _statusStyle = AppTextStyles.titleMediumBold.copyWith(
  color: AppColors.secondary500,
);
