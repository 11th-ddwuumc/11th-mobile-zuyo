class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.genres,
    required this.year,
    required this.posterAsset,
    this.runtimeMinutes,
    this.tags = const [],
  });

  final int id;
  final String title;
  // 상세 페이지 및 추천 신작에 보여줄 장르 & 태그
  final List<String> genres;
  final List<String> tags;
  final int year;
  final String posterAsset;
  // 추천신작에 보여주기 위해 추가
  final int? runtimeMinutes;
}

const movies = [
  Movie(
    id: 1,
    title: '별빛 아래 우리',
    genres: ['로맨스', '드라마'],
    tags: ['감동적인'],
    runtimeMinutes: 120,
    year: 2024,
    posterAsset: 'assets/images/posters/hero_under_the_starlight.jpg',
  ),
  Movie(
    id: 2,
    title: '우주의 끝에서',
    genres: ['SF'],
    year: 2024,
    posterAsset: 'assets/images/posters/poster_echoes_of_the_void.jpg',
  ),
  Movie(
    id: 3,
    title: '기억의 숲',
    genres: ['애니메이션'],
    year: 2022,
    posterAsset: 'assets/images/posters/poster_whispering_woods.jpg',
  ),
  Movie(
    id: 4,
    title: '밤의 그림자',
    genres: ['스릴러'],
    year: 2024,
    posterAsset: 'assets/images/posters/poster_night_shadows.jpg',
  ),
  Movie(
    id: 5,
    title: '봄날의 커피',
    genres: ['로맨스'],
    year: 2021,
    posterAsset: 'assets/images/posters/poster_fourth_afternoon.jpg',
  ),
  Movie(
    id: 6,
    title: '도시의 선',
    genres: ['다큐멘터리'],
    year: 2023,
    posterAsset: 'assets/images/posters/poster_abyss_walker.jpg',
  ),
];

Movie? findMovieById(int? id) {
  for (final movie in movies) {
    if (movie.id == id) return movie;
  }
  return null;
}
