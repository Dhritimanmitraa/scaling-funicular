import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../constants/route_names.dart';

class BottomNavigationWidget extends StatelessWidget {
  final String currentRoute;

  const BottomNavigationWidget({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(currentRoute);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textLight,
      elevation: 8,
      onTap: (index) => _onTabTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Learn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz),
          label: 'Practice',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  int _getCurrentIndex(String route) {
    if (route.startsWith(RouteNames.dashboard)) return 0;
    if (route.startsWith(RouteNames.subjects) || 
        route.startsWith(RouteNames.chapters) ||
        route.startsWith(RouteNames.chapterDetail)) return 1;
    if (route.startsWith(RouteNames.quiz)) return 2;
    if (route.startsWith(RouteNames.profile)) return 3;
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.dashboard);
        break;
      case 1:
        // Navigate to subjects - would need current user's class ID
        // For now, go to dashboard
        context.go(RouteNames.dashboard);
        break;
      case 2:
        // Navigate to practice - could be a random quiz or practice mode
        context.go(RouteNames.dashboard);
        break;
      case 3:
        context.go(RouteNames.profile);
        break;
    }
  }
}
