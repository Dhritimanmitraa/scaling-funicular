import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/vr_video_card.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../curriculum/presentation/bloc/curriculum_bloc.dart';
import '../../../curriculum/presentation/bloc/curriculum_event.dart';
import '../../../curriculum/presentation/bloc/curriculum_state.dart';
import '../../../curriculum/presentation/screens/subjects_screen.dart';
import '../../../content/presentation/screens/vr_video_player.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load user's subjects when dashboard loads
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && authState.user.classId != null) {
      context.read<CurriculumBloc>().add(
        CurriculumSubjectsRequested(classId: authState.user.classId!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is! AuthAuthenticated) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final user = authState.user;
            
            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: AppColors.primary,
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Hello, Student!',
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
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60), // Account for app bar
                            Text(
                              'Ready to learn today?',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textOnPrimary.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildStatCard('Points', '${user.points}'),
                                const SizedBox(width: 16),
                                _buildStatCard('Streak', '${user.currentStreak} days'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Content
                SliverPadding(
                  padding: const EdgeInsets.all(24.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Subjects Section
                      const Text(
                        'Your Subjects',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: 16),
                      
                      BlocBuilder<CurriculumBloc, CurriculumState>(
                        builder: (context, state) {
                          if (state is CurriculumLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is CurriculumSubjectsLoaded) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.2,
                              ),
                              itemCount: state.subjects.length,
                              itemBuilder: (context, index) {
                                final subject = state.subjects[index];
                                return _buildSubjectCard(subject.name, _getSubjectIcon(subject.name));
                              },
                            );
                          } else if (state is CurriculumError) {
                            return _buildErrorWidget(state.message);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Quick Actions
                      const Text(
                        'Quick Actions',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: 16),
                      
                      _buildQuickActionCard(
                        'Continue Learning',
                        'Resume where you left off',
                        Icons.play_circle_filled,
                        () {
                          // TODO: Navigate to last viewed content
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      _buildQuickActionCard(
                        'Practice Quiz',
                        'Test your knowledge',
                        Icons.quiz,
                        () {
                          // TODO: Navigate to random quiz
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // VR Learning Section
                      const Text(
                        'VR Learning Experience',
                        style: AppTextStyles.h3,
                      ),
                      const SizedBox(height: 16),
                      
                      VRVideoCard(
                        title: 'Virtual Solar System Tour',
                        description: 'Explore our solar system in immersive 360° VR experience',
                        duration: '5:30',
                        thumbnail: 'assets/images/planets.png',
                        onTap: () => _onVRVideoTap(context, 0),
                      ),
                      const SizedBox(height: 16),
                      
                      VRVideoCard(
                        title: '3D Human Anatomy Lab',
                        description: 'Dive deep into human anatomy with interactive 360° exploration',
                        duration: '8:45',
                        thumbnail: 'assets/images/planets.png', // Using planets as placeholder
                        onTap: () => _onVRVideoTap(context, 1),
                      ),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.textOnPrimary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTextStyles.h4.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textOnPrimary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(String name, IconData icon) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Navigate to chapters - need to get subject ID from state
          final curriculumState = context.read<CurriculumBloc>().state;
          if (curriculumState is CurriculumSubjectsLoaded) {
            final subject = curriculumState.subjects.firstWhere(
              (s) => s.name == name,
              orElse: () => curriculumState.subjects.first,
            );
            context.push('/dashboard/subjects/chapters/${subject.id}');
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.secondary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: AppTextStyles.h4.copyWith(color: AppColors.error),
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
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthAuthenticated && authState.user.classId != null) {
                context.read<CurriculumBloc>().add(
                  CurriculumSubjectsRequested(classId: authState.user.classId!),
                );
              }
            },
            type: ButtonType.outlined,
            width: 120,
          ),
        ],
      ),
    );
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
    return Icons.school;
  }

  void _onVRVideoTap(BuildContext context, int index) {
    String videoPath;
    String title;
    String description;

    switch (index) {
      case 0:
        videoPath = 'assets/videos/solarsystem_vr.mp4';
        title = 'Virtual Solar System Tour';
        description = 'Explore our solar system in immersive 360° VR experience';
        break;
      case 1:
        videoPath = 'assets/videos/anatomy_vr.mp4';
        title = '3D Human Anatomy Lab';
        description = 'Dive deep into human anatomy with interactive 360° exploration';
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VRVideoPlayer(
          videoPath: videoPath,
          title: title,
          description: description,
        ),
      ),
    );
  }
}
