import 'package:json_annotation/json_annotation.dart';
import '../../../../core/models/user_model.dart';
import '../../domain/entities/auth_user.dart';

part 'auth_user_model.g.dart';

@JsonSerializable()
class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    super.boardId,
    super.classId,
    super.points,
    super.currentStreak,
    super.lastActiveDate,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  factory AuthUserModel.fromUserModel(UserModel userModel) {
    return AuthUserModel(
      id: userModel.id,
      email: userModel.email,
      boardId: userModel.boardId,
      classId: userModel.classId,
      points: userModel.points,
      currentStreak: userModel.currentStreak,
      lastActiveDate: userModel.lastActiveDate,
    );
  }

  UserModel toUserModel() {
    return UserModel(
      id: id,
      email: email,
      boardId: boardId,
      classId: classId,
      points: points,
      currentStreak: currentStreak,
      lastActiveDate: lastActiveDate,
      createdAt: DateTime.now(), // This would come from API
      updatedAt: DateTime.now(), // This would come from API
    );
  }
}
