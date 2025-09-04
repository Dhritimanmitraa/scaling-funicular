import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../content/presentation/bloc/content_bloc.dart';
import '../../../content/presentation/bloc/content_event.dart';
import '../../../content/presentation/bloc/content_state.dart';

class ChapterDetailScreen extends StatefulWidget {
  final String chapterId;

  const ChapterDetailScreen({
    super.key,
    required this.chapterId,
  });

  @override
  State<ChapterDetailScreen> createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  bool hasWatchedVideo = false; // TODO: Get from user progress
  bool hasCompletedQuiz = false; // TODO: Get from user progress
  int? lastQuizScore; // TODO: Get from user progress

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Chapter 1: Motion', // TODO: Get real chapter name
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textOnPrimary,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.school,
                    size: 80,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Chapter Summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chapter Overview',
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Learn about the fundamental concepts of motion, including distance, displacement, speed, velocity, and acceleration.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Video Lesson Section
                const Text(
                  'Video Lesson',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 16),
                
                _buildVideoLessonCard(),
                const SizedBox(height: 32),
                
                // Practice Quiz Section
                const Text(
                  'Practice Quiz',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 16),
                
                _buildQuizCard(),
                const SizedBox(height: 32),
                
                // Progress Section
                if (hasWatchedVideo || hasCompletedQuiz) ...[
                  const Text(
                    'Your Progress',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildProgressCard(),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoLessonCard() {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.play_circle_filled,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI-Generated Video',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasWatchedVideo ? 'Completed • 3 min' : 'Not Started • ~3 min',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: hasWatchedVideo ? AppColors.success : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (hasWatchedVideo)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            Text(
              'Watch a personalized video lesson explaining the core concepts of this chapter.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            
            CustomButton(
              text: hasWatchedVideo ? 'Watch Again' : 'Watch Lesson',
              onPressed: () => _watchVideo(),
              icon: Icons.play_arrow,
              type: hasWatchedVideo ? ButtonType.outlined : ButtonType.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard() {
    final isEnabled = hasWatchedVideo; // Quiz enabled only after video
    
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isEnabled 
                        ? AppColors.secondary.withOpacity(0.1)
                        : AppColors.lightGray,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.quiz,
                    size: 36,
                    color: isEnabled ? AppColors.secondary : AppColors.textLight,
                  ),
                ),
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chapter Quiz',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isEnabled ? AppColors.textPrimary : AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasCompletedQuiz 
                            ? 'Last Score: ${lastQuizScore ?? 0}/5 • 5 questions'
                            : isEnabled 
                                ? '5 questions • 5 min'
                                : 'Complete video first',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: hasCompletedQuiz 
                              ? AppColors.success 
                              : isEnabled 
                                  ? AppColors.textSecondary 
                                  : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (hasCompletedQuiz)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 24,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            Text(
              'Test your understanding with AI-generated questions based on the video content.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: isEnabled ? AppColors.textSecondary : AppColors.textLight,
              ),
            ),
            const SizedBox(height: 16),
            
            CustomButton(
              text: hasCompletedQuiz ? 'Retake Quiz' : 'Take Quiz',
              onPressed: isEnabled ? () => _takeQuiz() : null,
              icon: Icons.quiz,
              type: hasCompletedQuiz ? ButtonType.outlined : ButtonType.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    final videoProgress = hasWatchedVideo ? 1.0 : 0.0;
    final quizProgress = hasCompletedQuiz ? 1.0 : 0.0;
    final overallProgress = (videoProgress + quizProgress) / 2;

    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overall Progress',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${(overallProgress * 100).round()}%',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            LinearProgressIndicator(
              value: overallProgress,
              backgroundColor: AppColors.lightGray,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildProgressItem(
                    'Video',
                    hasWatchedVideo ? 'Completed' : 'Pending',
                    hasWatchedVideo,
                    Icons.play_circle_filled,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProgressItem(
                    'Quiz',
                    hasCompletedQuiz 
                        ? 'Score: ${lastQuizScore ?? 0}/5'
                        : hasWatchedVideo 
                            ? 'Available' 
                            : 'Locked',
                    hasCompletedQuiz,
                    Icons.quiz,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String title, String status, bool isCompleted, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted 
            ? AppColors.success.withOpacity(0.1)
            : AppColors.lightGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: isCompleted ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            status,
            style: AppTextStyles.bodySmall.copyWith(
              color: isCompleted ? AppColors.success : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _watchVideo() {
    // Navigate to video player
    context.push(
      '${RouteNames.videoPlayer}/${widget.chapterId}',
      extra: {'chapterId': widget.chapterId},
    );
  }

  void _takeQuiz() {
    // Navigate to quiz
    context.push(
      '${RouteNames.quiz}/${widget.chapterId}',
      extra: {'chapterId': widget.chapterId},
    );
  }
}
