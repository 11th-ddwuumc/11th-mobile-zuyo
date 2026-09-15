import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:movielog/favorite_genres.dart';
import 'package:movielog/profile_header.dart';
import 'package:movielog/stat_item.dart';
import 'package:movielog/theme/app_text_styles.dart';
import 'package:movielog/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16, right: 16, top: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 32,
            children: [
              // 프로필 헤더 - 이미지, 닉네임
              ProfileHeader(),
              // 통계 카드
              Row(
                spacing: 8,
                children: [
                  Expanded(child: StatItem(label: '본 영화', value: '342')),
                  Expanded(child: StatItem(label: '평점', value: '4.2')),
                  Expanded(child: StatItem(label: '즐겨찾기', value: '58')),
                ],
              ),
              // 선호 장르
              FavoriteGenres()
            ],
          ),
        ),
      ),
    );
  }
}