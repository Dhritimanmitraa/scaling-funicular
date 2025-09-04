import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';
import '../entities/auth_response.dart';
import '../entities/login_request.dart';
import '../entities/register_request.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> login(LoginRequest request);
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthUser>> getCurrentUser();
  Future<Either<Failure, AuthUser>> updateUserCurriculum({
    required String boardId,
    required String classId,
  });
  Future<bool> isLoggedIn();
}
