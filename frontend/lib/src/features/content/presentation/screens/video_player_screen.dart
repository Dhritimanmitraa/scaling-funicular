import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/services/analytics_service.dart';
import '../bloc/content_bloc.dart';
import '../bloc/content_event.dart';
import '../bloc/content_state.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String? chapterId;

  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    this.chapterId,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _isVideoCompleted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    setState(() => _isLoading = true);
    
    // Simulate video loading
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    
    // Log video play event
    await AnalyticsService.logVideoPlay(videoId: widget.videoId);
  }

  Future<void> _markVideoCompleted() async {
    if (_isVideoCompleted) return;
    
    setState(() => _isVideoCompleted = true);
    
    // Log video completion
    await AnalyticsService.logVideoComplete(videoId: widget.videoId);
    
    // Show completion dialog
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          '🎉 Video Completed!',
          style: AppTextStyles.h3.copyWith(color: AppColors.primary),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Great job! You\'ve completed this lesson.',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: AppColors.secondary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '+${AppConstants.videoCompletionPoints} Points',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          CustomButton(
            text: 'Continue',
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Video Lesson',
          style: AppTextStyles.h3,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Video Player Placeholder
                Container(
                  height: 250,
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.midGray),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Video Player',
                        style: AppTextStyles.h4,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Video ID: ${widget.videoId}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Video Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lesson Content',
                        style: AppTextStyles.h4,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This is a placeholder for the video content. In the full implementation, this would show the actual video player with controls.',
                        style: AppTextStyles.bodyLarge,
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Action Buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (!_isVideoCompleted)
                        CustomButton(
                          text: 'Mark as Complete',
                          onPressed: _markVideoCompleted,
                          width: double.infinity,
                        ),
                      if (_isVideoCompleted)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.success),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: AppColors.success),
                              const SizedBox(width: 8),
                              Text(
                                'Video Completed!',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}