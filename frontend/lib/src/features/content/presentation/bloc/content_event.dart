import 'package:equatable/equatable.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object?> get props => [];
}

class ContentVideoRequested extends ContentEvent {
  final String chapterId;

  const ContentVideoRequested({required this.chapterId});

  @override
  List<Object> get props => [chapterId];
}

class ContentVideoGenerateRequested extends ContentEvent {
  final String chapterId;

  const ContentVideoGenerateRequested({required this.chapterId});

  @override
  List<Object> get props => [chapterId];
}

class ContentVideoCompletedEvent extends ContentEvent {
  final String videoId;
  final String userId;
  final String chapterId;

  const ContentVideoCompletedEvent({
    required this.videoId,
    required this.userId,
    required this.chapterId,
  });

  @override
  List<Object> get props => [videoId, userId, chapterId];
}

class ContentQuizRequested extends ContentEvent {
  final String chapterId;

  const ContentQuizRequested({required this.chapterId});

  @override
  List<Object> get props => [chapterId];
}

class ContentQuizSubmitted extends ContentEvent {
  final String quizId;
  final Map<String, dynamic> answers;

  const ContentQuizSubmitted({
    required this.quizId,
    required this.answers,
  });

  @override
  List<Object> get props => [quizId, answers];
}

class ContentReset extends ContentEvent {
  const ContentReset();
}