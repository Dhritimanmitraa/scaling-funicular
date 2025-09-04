import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/models/content_model.dart';
import '../../domain/entities/video_content.dart';
import '../../domain/repositories/content_repository.dart';
import '../datasources/content_remote_datasource.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource remoteDataSource;

  ContentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, VideoContent>> getVideo(String chapterId) async {
    try {
      final result = await remoteDataSource.getVideo(chapterId);
      return Right(result);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VideoContent>> generateVideo(String chapterId) async {
    try {
      final result = await remoteDataSource.generateVideo(chapterId);
      return Right(result);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContentModel>> getQuiz(String chapterId) async {
    try {
      final result = await remoteDataSource.getQuiz(chapterId);
      return Right(result);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitQuiz(String quizId, Map<String, dynamic> answers) async {
    try {
      await remoteDataSource.submitQuiz(quizId, answers);
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markVideoCompleted(String videoId, String userId) async {
    try {
      await remoteDataSource.markVideoCompleted(videoId, userId);
      return const Right(null);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Failure _mapExceptionToFailure(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException:
        return NetworkFailure(exception.message);
      case ServerException:
        return ServerFailure(exception.message);
      case ContentGenerationException:
        return ContentGenerationFailure(exception.message);
      case NotFoundException:
        return ServerFailure('Content not found');
      default:
        return UnknownFailure(exception.message);
    }
  }
}
