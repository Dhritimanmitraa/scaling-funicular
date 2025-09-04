import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final StorageService storageService;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserProgress() async {
    try {
      final result = await remoteDataSource.getUserProgress();
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure('Profile features to be implemented'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProgress(Map<String, dynamic> progress) async {
    try {
      await remoteDataSource.updateUserProgress(progress);
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure('Profile features to be implemented'));
    }
  }
}
