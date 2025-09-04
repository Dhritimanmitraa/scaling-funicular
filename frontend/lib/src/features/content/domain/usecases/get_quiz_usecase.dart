import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/content_model.dart';
import '../repositories/content_repository.dart';

class GetQuizUseCase {
  final ContentRepository repository;

  GetQuizUseCase(this.repository);

  Future<Either<Failure, ContentModel>> call(String chapterId) async {
    return await repository.getQuiz(chapterId);
  }
}
