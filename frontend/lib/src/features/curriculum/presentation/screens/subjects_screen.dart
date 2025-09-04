import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/models/subject_model.dart';
import '../bloc/curriculum_bloc.dart';
import '../bloc/curriculum_event.dart';
import '../bloc/curriculum_state.dart';

class SubjectsScreen extends StatefulWidget {
  final String boardId;
  final String classId;

  const SubjectsScreen({
    super.key,
    required this.boardId,
    required this.classId,
  });

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CurriculumBloc>().add(
      CurriculumSubjectsRequested(classId: widget.classId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Subjects'),
        elevation: 0,
      ),
      body: BlocBuilder<CurriculumBloc, CurriculumState>(
        builder: (context, state) {
          if (state is CurriculumLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CurriculumSubjectsLoaded) {
            return _buildSubjectsGrid(state.subjects);
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

  Widget _buildSubjectsGrid(List<SubjectModel> subjects) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final subject = subjects[index];
                return _buildSubjectCard(subject);
              },
              childCount: subjects.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(SubjectModel subject) {
    final icon = _getSubjectIcon(subject.name);
    final color = _getSubjectColor(subject.name);

    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      child: InkWell(
        onTap: () => _navigateToChapters(subject),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                subject.name,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Progress indicator (placeholder)
              Container(
                width: double.infinity,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.3, // 30% progress placeholder
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              
              Text(
                '30% Complete', // Placeholder
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
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
              'Unable to Load Subjects',
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
                  CurriculumSubjectsRequested(classId: widget.classId),
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

  void _navigateToChapters(SubjectModel subject) {
    context.push('/dashboard/subjects/chapters/${subject.id}');
  }

  IconData _getSubjectIcon(String subjectName) {
    final name = subjectName.toLowerCase();
    if (name.contains('math')) return Icons.calculate;
    if (name.contains('science') || name.contains('physics') || name.contains('chemistry')) {
      return Icons.science;
    }
    if (name.contains('history')) return Icons.history_edu;
    if (name.contains('english') || name.contains('language')) return Icons.book;
    if (name.contains('geography')) return Icons.public;
    if (name.contains('biology')) return Icons.biotech;
    if (name.contains('computer')) return Icons.computer;
    if (name.contains('art')) return Icons.palette;
    return Icons.school;
  }

  Color _getSubjectColor(String subjectName) {
    final name = subjectName.toLowerCase();
    if (name.contains('math')) return const Color(0xFF4CAF50);
    if (name.contains('science') || name.contains('physics') || name.contains('chemistry')) {
      return const Color(0xFF2196F3);
    }
    if (name.contains('history')) return const Color(0xFF795548);
    if (name.contains('english') || name.contains('language')) return const Color(0xFF9C27B0);
    if (name.contains('geography')) return const Color(0xFF009688);
    if (name.contains('biology')) return const Color(0xFF8BC34A);
    if (name.contains('computer')) return const Color(0xFF607D8B);
    if (name.contains('art')) return const Color(0xFFE91E63);
    return AppColors.primary;
  }
}
