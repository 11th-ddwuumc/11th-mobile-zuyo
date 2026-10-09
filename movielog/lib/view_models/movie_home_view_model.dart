import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movielog/models/tmdb_genre_dto.dart';
import 'package:movielog/models/tmdb_movie_dto.dart';
import 'package:movielog/services/tmdb_movie_service.dart';

enum MovieHomeLoadStatus { idle, loading, success, empty, error }

class MovieHomeViewModel extends ChangeNotifier {
  MovieHomeViewModel(this._service);
  final TmdbMovieService _service;

  List<TmdbMovieDto> popularMovies = const [];
  List<TmdbGenreDto> genres = const [];
  MovieHomeLoadStatus status = MovieHomeLoadStatus.idle;
  String? message;
  bool _disposed = false;

  Future<void> loadPopular() async {
    status = MovieHomeLoadStatus.loading;
    notifyListeners();

    try {
      final fetchedGenres = await _service.fetchGenres();
      final page = await _service.fetchPopular();
      
      if (_disposed) return;
      
      genres = fetchedGenres;
      popularMovies = page.results.take(5).toList();
      status = popularMovies.isEmpty
          ? MovieHomeLoadStatus.empty
          : MovieHomeLoadStatus.success;
    } on DioException {
      if (_disposed) return;
      status = MovieHomeLoadStatus.error;
      message = '인기 영화를 불러오지 못했어요.';
    }

    notifyListeners();
  }

  List<String> genreNamesFor(TmdbMovieDto movie) {
    final namesById = {
      for (final genre in genres) genre.id: genre.name,
    };

    return [
      for (final id in movie.genreIds)
        if (namesById[id] != null) namesById[id]!,
    ];
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
