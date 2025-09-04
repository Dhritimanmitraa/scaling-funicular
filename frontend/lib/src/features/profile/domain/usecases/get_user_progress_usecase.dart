import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class GetUserProgressUseCase {
  final ProfileRepository repository;

  GetUserProgressUseCase(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() async {
    return await repository.getUserProgress();
  }
}
