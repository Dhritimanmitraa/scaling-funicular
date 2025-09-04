import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProgressUseCase {
  final ProfileRepository repository;

  UpdateUserProgressUseCase(this.repository);

  Future<Either<Failure, void>> call(Map<String, dynamic> progress) async {
    return await repository.updateUserProgress(progress);
  }
}
