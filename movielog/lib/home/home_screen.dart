import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/common_app_bar.dart';
import 'package:movielog/home/featured_movie_card.dart';
import 'package:movielog/movie/movie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'MovieLog'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 24),
          child: FeaturedMovieCard(
            movie: movies.first,
            onTap: () => context.push('/movies/${movies.first.id}'),
          ),
        ),
      ),
    );
  }
}
