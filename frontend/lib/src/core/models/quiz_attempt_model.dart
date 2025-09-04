import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'quiz_attempt_model.g.dart';

@JsonSerializable()
class QuizAttemptModel extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'quiz_content_id')
  final String quizContentId;
  final int score;
  @JsonKey(name: 'total_questions')
  final int totalQuestions;
  @JsonKey(name: 'attempted_at')
  final DateTime attemptedAt;

  const QuizAttemptModel({
    required this.id,
    required this.userId,
    required this.quizContentId,
    required this.score,
    required this.totalQuestions,
    required this.attemptedAt,
  });

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) =>
      _$QuizAttemptModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuizAttemptModelToJson(this);

  double get percentage => (score / totalQuestions) * 100;

  @override
  List<Object> get props => [
        id,
        userId,
        quizContentId,
        score,
        totalQuestions,
        attemptedAt,
      ];
}
