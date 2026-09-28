import 'package:flutter/material.dart';
import 'package:movielog/common_app_bar.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movieId});

  final String movieId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: '영화 상세',
      ),
    );
  }
}