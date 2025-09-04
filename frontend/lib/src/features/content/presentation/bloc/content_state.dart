import 'package:equatable/equatable.dart';
import '../../../../core/models/content_model.dart';
import '../../domain/entities/video_content.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {
  const ContentInitial();
}

class ContentLoading extends ContentState {
  const ContentLoading();
}

class ContentVideoGenerating extends ContentState {
  final String chapterId;
  final String message;

  const ContentVideoGenerating({
    required this.chapterId,
    this.message = 'Generating your custom lesson...',
  });

  @override
  List<Object> get props => [chapterId, message];
}

class ContentVideoLoaded extends ContentState {
  final VideoContent video;

  const ContentVideoLoaded({required this.video});

  @override
  List<Object> get props => [video];
}

class ContentVideoCompleted extends ContentState {
  final String videoId;
  final int pointsEarned;

  const ContentVideoCompleted({
    required this.videoId,
    required this.pointsEarned,
  });

  @override
  List<Object> get props => [videoId, pointsEarned];
}

class ContentQuizLoaded extends ContentState {
  final ContentModel quiz;

  const ContentQuizLoaded({required this.quiz});

  @override
  List<Object> get props => [quiz];
}

class ContentQuizCompleted extends ContentState {
  final int score;
  final int totalQuestions;
  final int pointsEarned;

  const ContentQuizCompleted({
    required this.score,
    required this.totalQuestions,
    required this.pointsEarned,
  });

  @override
  List<Object> get props => [score, totalQuestions, pointsEarned];
}

class ContentError extends ContentState {
  final String message;

  const ContentError({required this.message});

  @override
  List<Object> get props => [message];
}
