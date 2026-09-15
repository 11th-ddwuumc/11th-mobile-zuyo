import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:movielog/profile_header.dart';
import 'package:movielog/stat_item.dart';
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
            children: [
              ProfileHeader(),

              const SizedBox(height: 32),

              Row(
                spacing: 8,
                children: [
                  Expanded(child: StatItem(label: '본 영화', value: '342')),
                  Expanded(child: StatItem(label: '평점', value: '4.2')),
                  Expanded(child: StatItem(label: '즐겨찾기', value: '58')),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
}


@Preview(name: '프로필 화면', size: Size(390, 844))
Widget profileScreenPreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: const ProfileScreen(),
  );
}