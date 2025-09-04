import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/analytics_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/entities/register_request.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final StorageService storageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<Either<Failure, AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await remoteDataSource.login(request);
      
      // Store tokens and user data
      await storageService.saveAccessToken(response.accessToken);
      await storageService.saveRefreshToken(response.refreshToken);
      await storageService.saveUserData(
        (response.user as AuthUserModel).toUserModel(),
      );

      // Update onboarding status if user has selected curriculum
      if (response.user.hasCompletedCurriculumSelection) {
        await storageService.setOnboardingCompleted(true);
      }

      // Log analytics
      await AnalyticsService.logLogin(method: 'email');
      await AnalyticsService.setUserProperties(
        userId: response.user.id,
        userType: 'student',
      );

      return Right(response);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register(RegisterRequest request) async {
    try {
      final response = await remoteDataSource.register(request);
      
      // Store tokens and user data
      await storageService.saveAccessToken(response.accessToken);
      await storageService.saveRefreshToken(response.refreshToken);
      await storageService.saveUserData(
        (response.user as AuthUserModel).toUserModel(),
      );

      // Update onboarding status if user has selected curriculum
      if (response.user.hasCompletedCurriculumSelection) {
        await storageService.setOnboardingCompleted(true);
      }

      // Log analytics
      await AnalyticsService.logSignUp(method: 'email');
      await AnalyticsService.setUserProperties(
        userId: response.user.id,
        userType: 'student',
      );

      return Right(response);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await storageService.logout();
      return const Right(null);
    } on AppException catch (e) {
      // Even if remote logout fails, clear local data
      await storageService.logout();
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      // Even if remote logout fails, clear local data
      await storageService.logout();
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> getCurrentUser() async {
    try {
      // First try to get from local storage
      final localUser = await storageService.getUserData();
      if (localUser != null) {
        return Right(AuthUserModel.fromUserModel(localUser));
      }

      // If not found locally, fetch from remote
      final remoteUser = await remoteDataSource.getCurrentUser();
      await storageService.saveUserData(remoteUser.toUserModel());
      
      return Right(remoteUser);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> updateUserCurriculum({
    required String boardId,
    required String classId,
  }) async {
    try {
      final updatedUser = await remoteDataSource.updateUserCurriculum(
        boardId: boardId,
        classId: classId,
      );

      // Update local storage
      await storageService.saveUserData(updatedUser.toUserModel());
      await storageService.setSelectedBoard(boardId);
      await storageService.setSelectedClass(classId);
      await storageService.setOnboardingCompleted(true);

      // Update analytics
      await AnalyticsService.setUserProperties(
        userId: updatedUser.id,
        userType: 'student',
      );

      return Right(updatedUser);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await storageService.isLoggedIn();
  }

  Failure _mapExceptionToFailure(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException:
        return NetworkFailure(exception.message);
      case UnauthorizedException:
        return AuthenticationFailure(exception.message);
      case ValidationException:
        return ValidationFailure(exception.message);
      case ServerException:
        return ServerFailure(exception.message);
      default:
        return UnknownFailure(exception.message);
    }
  }
}
