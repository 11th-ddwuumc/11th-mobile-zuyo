import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/models/tmdb_movie_dto.dart';
import 'package:movielog/screen/movie/widgets/movie_card.dart';

class MovieGrid extends StatelessWidget {
  const MovieGrid({
    super.key,
    required this.movies,
    required this.genreNamesFor,
    this.footer,
  });

  final List<TmdbMovieDto> movies;
  final List<String> Function(TmdbMovieDto) genreNamesFor;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const columnSpacing = 16.0;
        final cardWidth = (constraints.maxWidth - columnSpacing) / 2;

        final posterHeight = cardWidth * 1.5;
        const infoHeight = 8.0 + 24.0 + 24.0;
        final cardHeight = posterHeight + 4.0 + infoHeight;

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 16),
              sliver: SliverGrid.builder(
                itemCount: movies.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: columnSpacing,
                  mainAxisSpacing: 24,
                  mainAxisExtent: cardHeight,
                ),

                itemBuilder: (context, index) {
                  final movie = movies[index];

                  return MovieCard(
                    movie: movie,
                    genreNames: genreNamesFor(movie),
                    onTap: () =>
                        context.push('/movies/${movie.id}', extra: movie),
                  );
                },
              ),
            ),
            if (footer != null) SliverToBoxAdapter(child: footer),
          ],
        );
      },
    );
  }
}
