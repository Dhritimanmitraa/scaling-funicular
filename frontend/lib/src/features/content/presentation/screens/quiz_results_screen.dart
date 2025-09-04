import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/services/analytics_service.dart';

class QuizResultsScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int pointsEarned;
  final String? chapterId;
  final int? timeTaken;

  const QuizResultsScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.pointsEarned,
    this.chapterId,
    this.timeTaken,
  });

  @override
  State<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends State<QuizResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _logQuizCompletion();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();
  }

  void _logQuizCompletion() {
    if (widget.chapterId != null) {
      AnalyticsService.logQuizComplete(
        quizId: widget.chapterId!,
        score: widget.score,
      );
    }
  }

  double get percentage => (widget.score / widget.totalQuestions) * 100;

  Color get resultColor {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return AppColors.secondary;
    return AppColors.error;
  }

  String get resultMessage {
    if (percentage >= 80) return 'Excellent Work!';
    if (percentage >= 60) return 'Good Job!';
    return 'Keep Practicing!';
  }

  IconData get resultIcon {
    if (percentage >= 80) return Icons.emoji_events;
    if (percentage >= 60) return Icons.thumb_up;
    return Icons.school;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.go(RouteNames.dashboard);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Quiz Results'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.go(RouteNames.dashboard),
            ),
          ],
        ),
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    
                    // Result Icon and Message
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: resultColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(
                          resultIcon,
                          size: 60,
                          color: resultColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Text(
                      'Quiz Completed!',
                      style: AppTextStyles.h2.copyWith(
                        color: resultColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    
                    Text(
                      resultMessage,
                      style: AppTextStyles.h4,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Score Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            resultColor.withOpacity(0.1),
                            resultColor.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: resultColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'You scored',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${widget.score}',
                                  style: AppTextStyles.h1.copyWith(
                                    color: resultColor,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' / ${widget.totalQuestions}',
                                  style: AppTextStyles.h3.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          Text(
                            '${percentage.round()}% Correct',
                            style: AppTextStyles.h4.copyWith(
                              color: resultColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Stats Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Points Earned',
                            '+${widget.pointsEarned}',
                            Icons.star,
                            AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Time Taken',
                            _formatTime(widget.timeTaken ?? 0),
                            Icons.timer,
                            AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    // Performance Message
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _getPerformanceMessage(),
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getPerformanceTip(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    CustomButton(
                      text: 'Continue Learning',
                      onPressed: () => context.go(RouteNames.dashboard),
                      icon: Icons.school,
                    ),
                    const SizedBox(height: 16),
                    
                    CustomButton(
                      text: 'Retake Quiz',
                      onPressed: () {
                        context.pushReplacement(
                          '${RouteNames.quiz}/${widget.chapterId}',
                          extra: {'chapterId': widget.chapterId},
                        );
                      },
                      type: ButtonType.outlined,
                      icon: Icons.refresh,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h4.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }

  String _getPerformanceMessage() {
    if (percentage >= 80) {
      return 'Outstanding! You have mastered this chapter.';
    } else if (percentage >= 60) {
      return 'Well done! You have a good understanding.';
    } else {
      return 'Don\'t worry! Practice makes perfect.';
    }
  }

  String _getPerformanceTip() {
    if (percentage >= 80) {
      return 'You\'re ready to move on to the next chapter!';
    } else if (percentage >= 60) {
      return 'Review the video lesson to strengthen your understanding.';
    } else {
      return 'Watch the video lesson again and try the quiz once more.';
    }
  }
}
