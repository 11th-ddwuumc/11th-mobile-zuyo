import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movielog/theme/app_colors.dart';
import 'package:movielog/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    required this.child,
    required this.currentIndex,
  });
  
  final Widget child;
  final int currentIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 어느 탭으로 진입하든 내 정보를 한 번 불러와 AuthViewModel.member에 보관합니다.
      if (!mounted) return;
      context.read<AuthViewModel>().loadMember();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.currentIndex,
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