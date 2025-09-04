import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/subject_model.dart';
import '../repositories/curriculum_repository.dart';

class GetSubjectsUseCase {
  final CurriculumRepository repository;

  GetSubjectsUseCase(this.repository);

  Future<Either<Failure, List<SubjectModel>>> call(String classId) async {
    return await repository.getSubjects(classId);
  }
}
