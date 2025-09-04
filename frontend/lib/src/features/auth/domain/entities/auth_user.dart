import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? boardId;
  final String? classId;
  final int points;
  final int currentStreak;
  final DateTime? lastActiveDate;

  const AuthUser({
    required this.id,
    required this.email,
    this.boardId,
    this.classId,
    this.points = 0,
    this.currentStreak = 0,
    this.lastActiveDate,
  });

  bool get hasCompletedCurriculumSelection =>
      boardId != null && classId != null;

  @override
  List<Object?> get props => [
        id,
        email,
        boardId,
        classId,
        points,
        currentStreak,
        lastActiveDate,
      ];
}
