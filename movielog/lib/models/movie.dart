class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.genres,
    required this.year,
    required this.posterAsset,
    required this.rating,
    this.runtimeMinutes,
    this.tags = const [],
    this.synopsis = '',
  });

  final int id;
  final String title;
  // 상세 페이지 및 추천 신작에 보여줄 장르 & 태그
  final List<String> genres;
  final List<String> tags;
  final int year;
  final String posterAsset;
  // 목록과 상세에 공통으로 표시하는 Mock 평균 평점 (내가 입력한 평점과 별개).
  final double rating;
  // 추천신작에 보여주기 위해 추가
  final int? runtimeMinutes;
  final String synopsis;
}

const movies = [
  Movie(
    id: 1,
    rating: 4.5,
    title: '별빛 아래 우리',
    genres: ['로맨스', '드라마'],
    tags: ['감동적인'],
    runtimeMinutes: 120,
    year: 2024,
    posterAsset: 'assets/images/posters/hero_under_the_starlight.jpg',
    synopsis:
    '바쁜 현대 사회 속에서 서로의 존재를 잊고 살아가던 두 남녀가 우연한 계기로 작은 천문대에서 만나게 됩니다. '
    '매일 밤 별을 관측하며 서로의 상처를 치유하고, 잊고 있던 꿈과 사랑을 다시금 깨닫게 되는 따뜻한 이야기입니다.\n\n'
    '과거의 아픔으로 인해 사람에게 마음을 열지 못하던 여주인공은, 별자리처럼 변함없는 모습으로 자신을 기다려주는 남주인공을 통해 서서히 마음의 문을 열게 됩니다. '
    '하지만 두 사람 앞에 놓인 현실적인 장벽들은 그들의 관계를 시험하게 되는데...\n\n'
    '별이 쏟아지는 밤하늘 아래, 그들이 나눈 조용한 약속들은 과연 영원할 수 있을까요? '
    '눈부신 영상미와 감성적인 OST가 어우러져 깊은 여운을 남기는 올 겨울 최고의 로맨스 영화.\n\n'
    '잔잔한 감동과 함께 삶의 의미를 다시 한번 되돌아보게 만드는 수작입니다.',
  ),
  Movie(
    id: 2,
    rating: 4.2,
    title: '우주의 끝에서',
    genres: ['SF'],
    year: 2024,
    posterAsset: 'assets/images/posters/poster_echoes_of_the_void.jpg',
  ),
  Movie(
    id: 3,
    rating: 4.9,
    title: '기억의 숲',
    genres: ['애니메이션'],
    year: 2022,
    posterAsset: 'assets/images/posters/poster_whispering_woods.jpg',
  ),
  Movie(
    id: 4,
    rating: 3.8,
    title: '밤의 그림자',
    genres: ['스릴러'],
    year: 2024,
    posterAsset: 'assets/images/posters/poster_night_shadows.jpg',
  ),
  Movie(
    id: 5,
    rating: 4.5,
    title: '봄날의 커피',
    genres: ['로맨스'],
    year: 2021,
    posterAsset: 'assets/images/posters/poster_fourth_afternoon.jpg',
  ),
  Movie(
    id: 6,
    rating: 4.1,
    title: '도시의 선',
    genres: ['다큐멘터리'],
    year: 2023,
    posterAsset: 'assets/images/posters/poster_modern_architecture.jpg',
  ),
  Movie(
    id: 7,
    rating: 4.8,
    title: '마션 레스큐',
    genres: ['SF'],
    year: 2022,
    posterAsset: 'assets/images/posters/poster_abyss_walker.jpg' 
  ),
  Movie(
    id: 8,
    rating: 4.6,
    title: '스파이 코드',
    genres: ['액션'],
    year: 2021,
    posterAsset: 'assets/images/posters/poster_mission_improbable.jpg' 
  ),
  Movie(
    id: 9,
    rating: 4.4,
    title: '비오는 날의 기억',
    genres: ['스릴러'],
    year: 2022,
    posterAsset: 'assets/images/posters/poster_shadow_tide.jpg' 
  ),
];

Movie? findMovieById(int? id) {
  for (final movie in movies) {
    if (movie.id == id) return movie;
  }
  return null;
}
