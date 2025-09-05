import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/route_names.dart';
import '../services/service_locator.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/curriculum_selection_screen.dart';
import '../../features/home/presentation/screens/dashboard_screen.dart';
import '../../features/curriculum/presentation/screens/subjects_screen.dart';
import '../../features/curriculum/presentation/screens/chapters_screen.dart';
import '../../features/curriculum/presentation/screens/chapter_detail_screen.dart';
import '../../features/content/presentation/screens/video_player_screen.dart';
import '../../features/content/presentation/screens/quiz_screen.dart';
import '../../features/content/presentation/screens/quiz_results_screen.dart';
import '../../features/content/presentation/screens/vr_video_selection_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    redirect: _redirect,
    routes: [
      // Splash Screen
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Authentication Routes
      GoRoute(
        path: RouteNames.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return RegisterScreen(
            selectedBoardId: extra?['selectedBoardId'] as String?,
            selectedClassId: extra?['selectedClassId'] as String?,
          );
        },
      ),
      GoRoute(
        path: RouteNames.curriculumSelection,
        name: 'curriculum-selection',
        builder: (context, state) => const CurriculumSelectionScreen(),
      ),
      GoRoute(
        path: RouteNames.vrVideoSelection,
        name: 'vr-video-selection',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return VRVideoSelectionScreen(
            boardId: extra?['boardId'] as String? ?? '',
            classId: extra?['classId'] as String? ?? '',
            boardName: extra?['boardName'] as String? ?? '',
            classNumber: extra?['classNumber'] as int? ?? 0,
          );
        },
      ),

      // Main App Routes
      GoRoute(
        path: RouteNames.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          // Nested routes under dashboard
          GoRoute(
            path: 'subjects',
            name: 'subjects',
            builder: (context, state) {
              final boardId = state.pathParameters[RouteNames.boardIdParam]!;
              final classId = state.pathParameters[RouteNames.classIdParam]!;
              return SubjectsScreen(
                boardId: boardId,
                classId: classId,
              );
            },
            routes: [
              GoRoute(
                path: 'chapters/:${RouteNames.subjectIdParam}',
                name: 'chapters',
                builder: (context, state) {
                  final subjectId = state.pathParameters[RouteNames.subjectIdParam]!;
                  return ChaptersScreen(subjectId: subjectId);
                },
                routes: [
                  GoRoute(
                    path: 'detail/:${RouteNames.chapterIdParam}',
                    name: 'chapter-detail',
                    builder: (context, state) {
                      final chapterId = state.pathParameters[RouteNames.chapterIdParam]!;
                      return ChapterDetailScreen(chapterId: chapterId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Content Routes
      GoRoute(
        path: '${RouteNames.videoPlayer}/:${RouteNames.videoIdParam}',
        name: 'video-player',
        builder: (context, state) {
          final videoId = state.pathParameters[RouteNames.videoIdParam]!;
          final chapterId = state.uri.queryParameters['chapterId'];
          return VideoPlayerScreen(
            videoId: videoId,
            chapterId: chapterId,
          );
        },
      ),
      GoRoute(
        path: '${RouteNames.quiz}/:${RouteNames.quizIdParam}',
        name: 'quiz',
        builder: (context, state) {
          final quizId = state.pathParameters[RouteNames.quizIdParam]!;
          final chapterId = state.uri.queryParameters['chapterId'];
          return QuizScreen(
            quizId: quizId,
            chapterId: chapterId,
          );
        },
      ),
      GoRoute(
        path: RouteNames.quizResults,
        name: 'quiz-results',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return QuizResultsScreen(
            score: extra?['score'] ?? 0,
            totalQuestions: extra?['totalQuestions'] ?? 0,
            pointsEarned: extra?['pointsEarned'] ?? 0,
            chapterId: extra?['chapterId'],
          );
        },
      ),

      // Profile Routes
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );

  static Future<String?> _redirect(BuildContext context, GoRouterState state) async {
    final storageService = ServiceLocator.storageService;
    
    // Check if user is logged in
    final isLoggedIn = await storageService.isLoggedIn();
    
    // Check if onboarding is completed
    final hasCompletedOnboarding = storageService.getOnboardingCompleted();
    
    final currentLocation = state.uri.toString();

    // If on splash screen, determine where to redirect
    if (currentLocation == RouteNames.splash) {
      if (!isLoggedIn) {
        return RouteNames.welcome;
      } else if (!hasCompletedOnboarding) {
        return RouteNames.curriculumSelection;
      } else {
        return RouteNames.dashboard;
      }
    }

    // If not logged in and trying to access protected routes
    if (!isLoggedIn && _isProtectedRoute(currentLocation)) {
      return RouteNames.welcome;
    }

    // If logged in but haven't completed onboarding
    if (isLoggedIn && !hasCompletedOnboarding && 
        currentLocation != RouteNames.curriculumSelection) {
      return RouteNames.curriculumSelection;
    }

    // If logged in and completed onboarding but trying to access auth screens
    if (isLoggedIn && hasCompletedOnboarding && _isAuthRoute(currentLocation)) {
      return RouteNames.dashboard;
    }

    return null; // No redirect needed
  }

  static bool _isProtectedRoute(String route) {
    final protectedRoutes = [
      RouteNames.dashboard,
      RouteNames.subjects,
      RouteNames.chapters,
      RouteNames.chapterDetail,
      RouteNames.videoPlayer,
      RouteNames.quiz,
      RouteNames.quizResults,
      RouteNames.profile,
    ];

    return protectedRoutes.any((protectedRoute) => 
        route.startsWith(protectedRoute));
  }

  static bool _isAuthRoute(String route) {
    final authRoutes = [
      RouteNames.welcome,
      RouteNames.login,
      RouteNames.register,
      RouteNames.curriculumSelection,
    ];

    return authRoutes.contains(route);
  }
}
