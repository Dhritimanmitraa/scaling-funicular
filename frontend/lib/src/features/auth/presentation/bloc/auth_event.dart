import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthCurriculumUpdateRequested extends AuthEvent {
  final String boardId;
  final String classId;

  const AuthCurriculumUpdateRequested({
    required this.boardId,
    required this.classId,
  });

  @override
  List<Object> get props => [boardId, classId];
}

class AuthUserRefreshRequested extends AuthEvent {
  const AuthUserRefreshRequested();
}
