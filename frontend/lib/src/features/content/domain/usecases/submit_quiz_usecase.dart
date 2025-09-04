import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/content_repository.dart';

class SubmitQuizUseCase {
  final ContentRepository repository;

  SubmitQuizUseCase(this.repository);

  Future<Either<Failure, void>> call(String quizId, Map<String, dynamic> answers) async {
    return await repository.submitQuiz(quizId, answers);
  }
}
