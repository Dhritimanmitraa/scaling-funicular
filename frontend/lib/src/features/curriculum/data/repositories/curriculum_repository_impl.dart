import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/models/board_model.dart';
import '../../../../core/models/class_model.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../core/models/chapter_model.dart';
import '../../domain/repositories/curriculum_repository.dart';
import '../datasources/curriculum_remote_datasource.dart';

class CurriculumRepositoryImpl implements CurriculumRepository {
  final CurriculumRemoteDataSource remoteDataSource;

  CurriculumRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BoardModel>>> getBoards() async {
    try {
      final boards = await remoteDataSource.getBoards();
      return Right(boards);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ClassModel>>> getClasses(String boardId) async {
    try {
      final classes = await remoteDataSource.getClasses(boardId);
      return Right(classes);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SubjectModel>>> getSubjects(String classId) async {
    try {
      final subjects = await remoteDataSource.getSubjects(classId);
      return Right(subjects);
    } on AppException catch (e) {
      return Left(_mapExceptionToFailure(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChapterModel>>> getChapters(String subjectId) async {
    try {
      final chapters = await remoteDataSource.getChapters(subjectId);
      return Right(chapters);
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
      case NotFoundException:
        return ServerFailure('Content not found');
      default:
        return UnknownFailure(exception.message);
    }
  }
}
