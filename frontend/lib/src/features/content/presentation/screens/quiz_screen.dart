import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/route_names.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_overlay.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/models/content_model.dart';
import '../bloc/content_bloc.dart';
import '../bloc/content_event.dart';
import '../bloc/content_state.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;
  final String? chapterId;

  const QuizScreen({
    super.key,
    required this.quizId,
    this.chapterId,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  Map<int, String> selectedAnswers = {};
  Timer? _timer;
  int remainingTime = AppConstants.quizTimeLimit; // 5 minutes
  bool quizStarted = false;
  DateTime? startTime;

  @override
  void initState() {
    super.initState();
    if (widget.chapterId != null) {
      context.read<ContentBloc>().add(
        ContentQuizRequested(chapterId: widget.chapterId!),
      );
    }
  }

  void _startTimer() {
    if (quizStarted) return;
    
    setState(() {
      quizStarted = true;
      startTime = DateTime.now();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        _submitQuiz();
      }
    });

    // Log quiz start
    if (widget.chapterId != null) {
      AnalyticsService.logQuizStart(
        quizId: widget.chapterId!,
      );
    }
  }

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion(List<QuizQuestion> questions) {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void _submitQuiz() {
    _timer?.cancel();
    
    // Convert answers to format expected by backend
    final answersMap = <String, dynamic>{};
    for (final entry in selectedAnswers.entries) {
      answersMap['question_${entry.key}'] = entry.value;
    }

    context.read<ContentBloc>().add(
      ContentQuizSubmitted(
        quizId: widget.quizId,
        answers: answersMap,
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContentBloc, ContentState>(
      listener: (context, state) {
        if (state is ContentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        } else if (state is ContentQuizCompleted) {
          // Navigate to results screen
          context.pushReplacement(
            RouteNames.quizResults,
            extra: {
              'score': state.score,
              'totalQuestions': state.totalQuestions,
              'pointsEarned': state.pointsEarned,
              'chapterId': widget.chapterId,
              'timeTaken': startTime != null 
                  ? DateTime.now().difference(startTime!).inSeconds
                  : 0,
            },
          );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (!didPop) {
            _showExitConfirmation();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Quiz'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: _showExitConfirmation,
            ),
            actions: [
              if (quizStarted)
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: remainingTime < 60 ? AppColors.error : AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 16,
                        color: AppColors.textOnPrimary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(remainingTime),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          body: BlocBuilder<ContentBloc, ContentState>(
            builder: (context, state) {
              if (state is ContentLoading) {
                return const LoadingOverlay(
                  isLoading: true,
                  message: 'Generating your quiz...',
                  child: SizedBox(),
                );
              } else if (state is ContentQuizLoaded) {
                final questions = state.quiz.quizQuestions ?? [];
                if (questions.isEmpty) {
                  return _buildErrorWidget('No questions available');
                }
                
                if (!quizStarted) {
                  return _buildQuizIntro(questions.length);
                }
                
                return _buildQuizContent(questions);
              } else if (state is ContentError) {
                return _buildErrorWidget(state.message);
              }
              
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuizIntro(int totalQuestions) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.quiz,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          
          const Text(
            'Ready for the Quiz?',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          Text(
            'Test your understanding with $totalQuestions questions',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          _buildQuizInfoCard(totalQuestions),
          const SizedBox(height: 32),
          
          CustomButton(
            text: 'Start Quiz',
            onPressed: _startTimer,
            icon: Icons.play_arrow,
          ),
        ],
      ),
    );
  }

  Widget _buildQuizInfoCard(int totalQuestions) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.quiz, 'Questions', '$totalQuestions'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.timer, 'Time Limit', _formatTime(AppConstants.quizTimeLimit)),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.star, 'Points per Question', '${AppConstants.correctAnswerPoints}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTextStyles.bodyMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildQuizContent(List<QuizQuestion> questions) {
    final currentQuestion = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;
    
    return Column(
      children: [
        // Progress Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1} of ${questions.length}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(progress * 100).round()}%',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.lightGray,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ],
          ),
        ),
        
        // Question Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question Text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    currentQuestion.question,
                    style: AppTextStyles.h4,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Options
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestion.options.length,
                    itemBuilder: (context, optionIndex) {
                      final option = currentQuestion.options[optionIndex];
                      final isSelected = selectedAnswers[currentQuestionIndex] == option;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _selectAnswer(option),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? AppColors.primary.withOpacity(0.1)
                                  : AppColors.cardBackground,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.midGray,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? AppColors.primary : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : AppColors.midGray,
                                      width: 2,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: AppColors.textOnPrimary,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Navigation Buttons
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              if (currentQuestionIndex > 0)
                Expanded(
                  child: CustomButton(
                    text: 'Previous',
                    onPressed: _previousQuestion,
                    type: ButtonType.outlined,
                  ),
                ),
              if (currentQuestionIndex > 0) const SizedBox(width: 16),
              
              Expanded(
                flex: currentQuestionIndex == 0 ? 1 : 1,
                child: CustomButton(
                  text: currentQuestionIndex == questions.length - 1 
                      ? 'Submit Quiz' 
                      : 'Next Question',
                  onPressed: selectedAnswers.containsKey(currentQuestionIndex)
                      ? () {
                          if (currentQuestionIndex == questions.length - 1) {
                            _showSubmitConfirmation();
                          } else {
                            _nextQuestion(questions);
                          }
                        }
                      : null,
                  icon: currentQuestionIndex == questions.length - 1 
                      ? Icons.send 
                      : Icons.arrow_forward,
                ),
              ),
            ],
          ),
        ),
      ],
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
              'Quiz Unavailable',
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
                if (widget.chapterId != null) {
                  context.read<ContentBloc>().add(
                    ContentQuizRequested(chapterId: widget.chapterId!),
                  );
                }
              },
              type: ButtonType.outlined,
              width: 120,
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text('Are you sure you want to exit? Your progress will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: Text(
              'Exit',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSubmitConfirmation() {
    final answeredQuestions = selectedAnswers.length;
    final totalQuestions = currentQuestionIndex + 1;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz?'),
        content: Text(
          'You have answered $answeredQuestions out of $totalQuestions questions. '
          'Are you sure you want to submit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Review'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _submitQuiz();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
