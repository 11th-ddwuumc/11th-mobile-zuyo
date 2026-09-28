import 'package:flutter/material.dart';
import 'package:movielog/common_app_bar.dart';
import 'package:movielog/movie/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context) {
    final movie = findMovieById(int.tryParse(movieId));
    return Scaffold(
      appBar: CommonAppBar(title: '영화 상세'),
      body: Center(child: Text(movie?.title ?? '영화를 찾을 수 없습니다.')),
    );
  }
}
