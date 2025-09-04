import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'content_model.g.dart';

enum ContentType {
  @JsonValue('video')
  video,
  @JsonValue('quiz')
  quiz,
}

@JsonSerializable()
class ContentModel extends Equatable {
  final String id;
  @JsonKey(name: 'chapter_id')
  final String chapterId;
  @JsonKey(name: 'content_type')
  final ContentType contentType;
  @JsonKey(name: 'content_data')
  final Map<String, dynamic> contentData;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const ContentModel({
    required this.id,
    required this.chapterId,
    required this.contentType,
    required this.contentData,
    required this.createdAt,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContentModelToJson(this);

  // Helper getters for video content
  String? get videoUrl => contentType == ContentType.video 
      ? contentData['video_url'] as String? 
      : null;

  int? get videoDuration => contentType == ContentType.video 
      ? contentData['duration'] as int? 
      : null;

  // Helper getters for quiz content
  List<QuizQuestion>? get quizQuestions {
    if (contentType != ContentType.quiz) return null;
    
    final questionsData = contentData['questions'] as List<dynamic>?;
    if (questionsData == null) return null;
    
    return questionsData
        .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
        .toList();
  }

  @override
  List<Object> get props => [id, chapterId, contentType, contentData, createdAt];
}

@JsonSerializable()
class QuizQuestion extends Equatable {
  @JsonKey(name: 'q')
  final String question;
  final List<String> options;
  final String answer;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);

  @override
  List<Object> get props => [question, options, answer];
}
