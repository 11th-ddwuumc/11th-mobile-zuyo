import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class TmdbConfig {
  static String get accessToken {
    final token = dotenv.env['TMDB_ACCESS_TOKEN']?.trim();

    if (token == null || token.isEmpty) {
      throw StateError('.env 파일에 TMDB_ACCESS_TOKEN을 설정해 주세요.');
    }

    return token;
  }
}
