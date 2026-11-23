import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movielog/view_models/auth_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/screen/profile/widgets/profile_menu_tile.dart';
import 'package:movielog/widgets/common_app_bar.dart';
import 'package:movielog/screen/profile/widgets/favorite_genres.dart';
import 'package:movielog/screen/profile/widgets/profile_header.dart';
import 'package:movielog/screen/profile/widgets/stat_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final member = auth.member;
    return Scaffold(
      appBar: CommonAppBar(
        title: '내 프로필',
        actions: [
          TextButton(
            onPressed: auth.storageCleanupInProgress ? null : auth.logout,
            child: const Text('로그아웃'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 32,
              children: [
                // 프로필 헤더 - 이미지, 닉네임
                if (member != null)
                  ProfileHeader(
                    nickname: member.nickname,
                    email: member.email,
                    onEdit: () => context.push('/my/profile/edit'),
                  )
                else if (auth.memberStatus == MemberLoadStatus.error)
                  Column(
                    children: [
                      Text(auth.message ?? '내 정보를 불러오지 못했어요.'),
                      TextButton(
                        onPressed: () => auth.loadMember(force: true),
                        child: const Text('다시 시도'),
                      ),
                    ],
                  )
                else
                  const Center(child: CircularProgressIndicator()),
                // 통계 카드
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: StatItem(
                        label: '본 영화',
                        value: '342',
                        iconPath: 'assets/icons/movie.svg',
                      ),
                    ),
                    Expanded(
                      child: StatItem(label: '평점', value: '4.2'),
                    ),
                    Expanded(
                      child: StatItem(label: '즐겨찾기', value: '58'),
                    ),
                  ],
                ),
                // 내가 등록한 평점
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    ProfileMenuTile(
                      title: '내가 등록한 평점',
                      onTap: () => context.push('/my/ratings'),
                    ),
                    ProfileMenuTile(
                      title: '내 즐겨찾기',
                      onTap: () => context.push('/my/favorites'),
                    ),
                  ],
                ),
                // 선호 장르
                FavoriteGenres(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
