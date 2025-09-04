import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/board_model.dart';
import '../../../../core/models/class_model.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../core/models/chapter_model.dart';

abstract class CurriculumRepository {
  Future<Either<Failure, List<BoardModel>>> getBoards();
  Future<Either<Failure, List<ClassModel>>> getClasses(String boardId);
  Future<Either<Failure, List<SubjectModel>>> getSubjects(String classId);
  Future<Either<Failure, List<ChapterModel>>> getChapters(String subjectId);
}
