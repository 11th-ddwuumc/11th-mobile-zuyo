import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/theme/app_colors.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
    required this.child,
    required this.currentIndex,
  });
  
  final Widget child;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        backgroundColor: AppColors.base,
        indicatorColor: AppColors.primary200,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/movies');
              break;
            case 2:
              context.go('/my');
              break;
          }
        },
        destinations: [
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              width: 24, height: 24,
              colorFilter: ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
            ),
            selectedIcon: SvgPicture.asset(
              'assets/icons/home_filled.svg',
              width: 16, height: 18,
              colorFilter: ColorFilter.mode(AppColors.selectedIcon, BlendMode.srcIn),
            ),
            label: '홈',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/icons/movie.svg',
              width: 24, height: 24,
              colorFilter: ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
            ),
            selectedIcon: SvgPicture.asset(
              'assets/icons/movie_filled.svg',
              width: 20, height: 16,
              colorFilter: ColorFilter.mode(AppColors.selectedIcon, BlendMode.srcIn),
            ),
            label: '영화',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/icons/person.svg',
              width: 24, height: 24,
              colorFilter: ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
            ),
            selectedIcon: SvgPicture.asset(
              'assets/icons/person_filled.svg',
              width: 16, height: 16,
              colorFilter: ColorFilter.mode(AppColors.selectedIcon, BlendMode.srcIn),
            ),
            label: '마이',
          ),
        ],
      ),
    );
  }
}