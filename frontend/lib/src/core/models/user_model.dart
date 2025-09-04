import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  @JsonKey(name: 'board_id')
  final String? boardId;
  @JsonKey(name: 'class_id')
  final String? classId;
  final int points;
  @JsonKey(name: 'current_streak')
  final int currentStreak;
  @JsonKey(name: 'last_active_date')
  final DateTime? lastActiveDate;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    this.boardId,
    this.classId,
    this.points = 0,
    this.currentStreak = 0,
    this.lastActiveDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? boardId,
    String? classId,
    int? points,
    int? currentStreak,
    DateTime? lastActiveDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      boardId: boardId ?? this.boardId,
      classId: classId ?? this.classId,
      points: points ?? this.points,
      currentStreak: currentStreak ?? this.currentStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        boardId,
        classId,
        points,
        currentStreak,
        lastActiveDate,
        createdAt,
        updatedAt,
      ];
}
