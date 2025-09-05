import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/models/board_model.dart';
import '../../../../core/models/class_model.dart';
import '../../../curriculum/presentation/bloc/curriculum_bloc.dart';
import '../../../curriculum/presentation/bloc/curriculum_event.dart';
import '../../../curriculum/presentation/bloc/curriculum_state.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class CurriculumSelectionScreen extends StatefulWidget {
  const CurriculumSelectionScreen({super.key});

  @override
  State<CurriculumSelectionScreen> createState() => _CurriculumSelectionScreenState();
}

class _CurriculumSelectionScreenState extends State<CurriculumSelectionScreen> {
  BoardModel? selectedBoard;
  ClassModel? selectedClass;
  List<ClassModel> availableClasses = [];

  @override
  void initState() {
    super.initState();
    // Load boards when screen initializes
    context.read<CurriculumBloc>().add(const CurriculumBoardsRequested());
  }

  void _onBoardSelected(BoardModel board) {
    print('Board selected: ${board.name}');
    setState(() {
      selectedBoard = board;
      selectedClass = null; // Reset class selection
      availableClasses = [];
    });
    
    // Load classes for selected board
    print('Loading classes for board: ${board.id}');
    context.read<CurriculumBloc>().add(
      CurriculumClassesRequested(boardId: board.id),
    );
  }

  void _onClassSelected(ClassModel classModel) {
    print('Class selected: Class ${classModel.classNumber}');
    setState(() {
      selectedClass = classModel;
    });
  }

  void _handleContinue() {
    print('Continue button clicked!');
    print('Selected Board: ${selectedBoard?.name}');
    print('Selected Class: ${selectedClass?.classNumber}');
    
    if (selectedBoard != null && selectedClass != null) {
      print('Both board and class selected, proceeding...');
      // Check if it's CBSE Class 12 - show VR video selection
      if (selectedBoard!.name.toLowerCase().contains('cbse') && 
          selectedClass!.classNumber == 12) {
        print('CBSE Class 12 detected, navigating to VR selection');
        context.go(RouteNames.vrVideoSelection, extra: {
          'boardId': selectedBoard!.id,
          'classId': selectedClass!.id,
          'boardName': selectedBoard!.name,
          'classNumber': selectedClass!.classNumber,
        });
      } else {
        print('Regular flow, navigating to register');
        // Regular flow for other boards/classes
        context.go(RouteNames.register, extra: {
          'selectedBoardId': selectedBoard!.id,
          'selectedClassId': selectedClass!.id,
        });
      }
    } else {
      print('Missing selection - Board: ${selectedBoard != null}, Class: ${selectedClass != null}');
    }
  }

  bool get canContinue => selectedBoard != null && selectedClass != null;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            } else if (state is AuthAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Setup completed successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
              context.go(RouteNames.dashboard);
            }
          },
        ),
        BlocListener<CurriculumBloc, CurriculumState>(
          listener: (context, state) {
            if (state is CurriculumClassesLoaded) {
              setState(() {
                availableClasses = state.classes;
              });
            } else if (state is CurriculumError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return LoadingOverlay(
            isLoading: authState is AuthLoading,
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      
                      // Header
                      const Text(
                        'Tell Us About Your Studies',
                        style: AppTextStyles.h2,
                      ),
                      const SizedBox(height: 8),
                      
                      Text(
                        'Select your educational board and class to get personalized content',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 48),
                      
                      // Board Selection
                      const Text(
                        'Educational Board',
                        style: AppTextStyles.h4,
                      ),
                      const SizedBox(height: 16),
                      
                      BlocBuilder<CurriculumBloc, CurriculumState>(
                        builder: (context, state) {
                          if (state is CurriculumLoading && selectedBoard == null) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is CurriculumBoardsLoaded) {
                            return _buildBoardSelection(state.boards);
                          } else if (state is CurriculumError) {
                            return _buildErrorWidget(state.message);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      
                      if (selectedBoard != null) ...[
                        const SizedBox(height: 32),
                        
                        // Class Selection
                        const Text(
                          'Class',
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: 16),
                        
                        BlocBuilder<CurriculumBloc, CurriculumState>(
                          builder: (context, state) {
                            if (state is CurriculumLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (availableClasses.isNotEmpty) {
                              return _buildClassSelection(availableClasses);
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                      
                      const Spacer(),
                      
                      // Continue Button
                      CustomButton(
                        text: 'Continue',
                        onPressed: canContinue ? _handleContinue : null,
                        isLoading: authState is AuthLoading,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBoardSelection(List<BoardModel> boards) {
    print('Building board selection with ${boards.length} boards');
    for (var board in boards) {
      print('Available board: ${board.name} (ID: ${board.id})');
    }
    return Column(
      children: boards.map((board) {
        final isSelected = selectedBoard?.id == board.id;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => _onBoardSelected(board),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.cardBackground,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.midGray,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.midGray,
                        width: 2,
                      ),
                      color: isSelected ? AppColors.primary : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 12,
                            color: AppColors.textOnPrimary,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    board.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildClassSelection(List<ClassModel> classes) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: classes.map((classModel) {
        final isSelected = selectedClass?.id == classModel.id;
        return GestureDetector(
          onTap: () => _onClassSelected(classModel),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.cardBackground,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.midGray,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              'Class ${classModel.classNumber}',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 48,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Retry',
            onPressed: () {
              context.read<CurriculumBloc>().add(const CurriculumBoardsRequested());
            },
            type: ButtonType.outlined,
            width: 120,
          ),
        ],
      ),
    );
  }
}
