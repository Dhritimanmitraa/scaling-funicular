import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class ProfileRepository {
  // Placeholder methods - to be implemented
  Future<Either<Failure, Map<String, dynamic>>> getUserProgress();
  Future<Either<Failure, void>> updateUserProgress(Map<String, dynamic> progress);
}
