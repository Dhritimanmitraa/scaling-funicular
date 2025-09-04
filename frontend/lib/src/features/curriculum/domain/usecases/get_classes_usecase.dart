import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/class_model.dart';
import '../repositories/curriculum_repository.dart';

class GetClassesUseCase {
  final CurriculumRepository repository;

  GetClassesUseCase(this.repository);

  Future<Either<Failure, List<ClassModel>>> call(String boardId) async {
    return await repository.getClasses(boardId);
  }
}
