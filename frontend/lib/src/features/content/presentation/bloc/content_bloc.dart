import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/repositories/content_repository.dart';
import 'content_event.dart';
import 'content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final ContentRepository contentService;

  ContentBloc({required this.contentService}) : super(const ContentInitial()) {
    on<ContentVideoRequested>(_onVideoRequested);
    on<ContentVideoGenerateRequested>(_onVideoGenerateRequested);
    on<ContentVideoCompletedEvent>(_onVideoCompleted);
    on<ContentQuizRequested>(_onQuizRequested);
    on<ContentQuizSubmitted>(_onQuizSubmitted);
    on<ContentReset>(_onReset);
  }

  Future<void> _onVideoRequested(
    ContentVideoRequested event,
    Emitter<ContentState> emit,
  ) async {
    emit(const ContentLoading());
    
    // First try to get existing video
    final result = await contentService.getVideo(event.chapterId);
    result.fold(
      (failure) {
        // If video doesn't exist, try to generate it
        add(ContentVideoGenerateRequested(chapterId: event.chapterId));
      },
      (video) => emit(ContentVideoLoaded(video: video)),
    );
  }

  Future<void> _onVideoGenerateRequested(
    ContentVideoGenerateRequested event,
    Emitter<ContentState> emit,
  ) async {
    emit(ContentVideoGenerating(chapterId: event.chapterId));
    
    final result = await contentService.generateVideo(event.chapterId);
    result.fold(
      (failure) => emit(ContentError(message: failure.message)),
      (video) => emit(ContentVideoLoaded(video: video)),
    );
  }

  Future<void> _onVideoCompleted(
    ContentVideoCompletedEvent event,
    Emitter<ContentState> emit,
  ) async {
    final result = await contentService.markVideoCompleted(
      event.videoId,
      event.userId,
    );
    
    result.fold(
      (failure) => emit(ContentError(message: failure.message)),
      (_) => emit(ContentVideoCompleted(
        videoId: event.videoId,
        pointsEarned: AppConstants.videoCompletionPoints,
      )),
    );
  }

  Future<void> _onQuizRequested(
    ContentQuizRequested event,
    Emitter<ContentState> emit,
  ) async {
    emit(const ContentLoading());
    
    final result = await contentService.getQuiz(event.chapterId);
    result.fold(
      (failure) => emit(ContentError(message: failure.message)),
      (quiz) => emit(ContentQuizLoaded(quiz: quiz)),
    );
  }

  Future<void> _onQuizSubmitted(
    ContentQuizSubmitted event,
    Emitter<ContentState> emit,
  ) async {
    emit(const ContentLoading());
    
    final result = await contentService.submitQuiz(event.quizId, event.answers);
    result.fold(
      (failure) => emit(ContentError(message: failure.message)),
      (_) {
        // Calculate score and points (this would come from backend in real implementation)
        final correctAnswers = event.answers.values.where((answer) => answer == true).length;
        final totalQuestions = event.answers.length;
        final pointsEarned = (correctAnswers * AppConstants.correctAnswerPoints) + 
                           AppConstants.quizCompletionBonus;
        
        emit(ContentQuizCompleted(
          score: correctAnswers,
          totalQuestions: totalQuestions,
          pointsEarned: pointsEarned,
        ));
      },
    );
  }

  void _onReset(
    ContentReset event,
    Emitter<ContentState> emit,
  ) {
    emit(const ContentInitial());
  }
}
