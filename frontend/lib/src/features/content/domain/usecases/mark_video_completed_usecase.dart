import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/content_repository.dart';

class MarkVideoCompletedUseCase {
  final ContentRepository repository;

  MarkVideoCompletedUseCase(this.repository);

  Future<Either<Failure, void>> call(String videoId, String userId) async {
    return await repository.markVideoCompleted(videoId, userId);
  }
}
