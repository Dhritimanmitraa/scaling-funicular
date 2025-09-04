import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/chapter_model.dart';
import '../repositories/curriculum_repository.dart';

class GetChaptersUseCase {
  final CurriculumRepository repository;

  GetChaptersUseCase(this.repository);

  Future<Either<Failure, List<ChapterModel>>> call(String subjectId) async {
    return await repository.getChapters(subjectId);
  }
}
