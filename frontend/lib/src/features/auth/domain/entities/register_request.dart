import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  final String email;
  final String password;
  final String? boardId;
  final String? classId;

  const RegisterRequest({
    required this.email,
    required this.password,
    this.boardId,
    this.classId,
  });

  @override
  List<Object?> get props => [email, password, boardId, classId];
}
