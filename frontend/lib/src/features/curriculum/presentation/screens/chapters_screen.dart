import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/models/chapter_model.dart';
import '../bloc/curriculum_bloc.dart';
import '../bloc/curriculum_event.dart';
import '../bloc/curriculum_state.dart';

class ChaptersScreen extends StatefulWidget {
  final String subjectId;

  const ChaptersScreen({
    super.key,
    required this.subjectId,
  });

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CurriculumBloc>().add(
      CurriculumChaptersRequested(subjectId: widget.subjectId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chapters'),
        elevation: 0,
      ),
      body: BlocBuilder<CurriculumBloc, CurriculumState>(
        builder: (context, state) {
          if (state is CurriculumLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CurriculumChaptersLoaded) {
            return _buildChaptersList(state.chapters);
          } else if (state is CurriculumError) {
            return _buildErrorWidget(state.message);
          }
          
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildChaptersList(List<ChapterModel> chapters) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: chapters.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return _buildChapterCard(chapter, index);
      },
    );
  }

  Widget _buildChapterCard(ChapterModel chapter, int index) {
    final isCompleted = false; // TODO: Get from user progress
    final hasVideo = true; // TODO: Check if video exists
    final hasQuiz = true; // TODO: Check if quiz exists

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToChapterDetail(chapter),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isCompleted 
                ? Border.all(color: AppColors.success.withOpacity(0.3), width: 2)
                : null,
          ),
          child: Row(
            children: [
              // Chapter Number Circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? AppColors.success 
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: AppColors.textOnPrimary,
                          size: 24,
                        )
                      : Text(
                          '${chapter.chapterNumber}',
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Chapter Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        if (hasVideo) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.play_circle_filled,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Video',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        
                        if (hasQuiz) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.quiz,
                                  size: 16,
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Quiz',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Status Indicator
              Column(
                children: [
                  if (isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 24,
                    )
                  else
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to Load Chapters',
              style: AppTextStyles.h3.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Retry',
              onPressed: () {
                context.read<CurriculumBloc>().add(
                  CurriculumChaptersRequested(subjectId: widget.subjectId),
                );
              },
              type: ButtonType.outlined,
              width: 120,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChapterDetail(ChapterModel chapter) {
    context.push('/dashboard/subjects/chapters/${widget.subjectId}/detail/${chapter.id}');
  }
}
