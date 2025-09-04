import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_progress_model.g.dart';

enum ProgressStatus {
  @JsonValue('completed')
  completed,
}

@JsonSerializable()
class UserProgressModel extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'content_id')
  final String contentId;
  final ProgressStatus status;
  @JsonKey(name: 'completed_at')
  final DateTime completedAt;

  const UserProgressModel({
    required this.id,
    required this.userId,
    required this.contentId,
    required this.status,
    required this.completedAt,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) =>
      _$UserProgressModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProgressModelToJson(this);

  @override
  List<Object> get props => [id, userId, contentId, status, completedAt];
}
