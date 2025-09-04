import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/video_content.dart';
import '../repositories/content_repository.dart';

class GenerateVideoUseCase {
  final ContentRepository repository;

  GenerateVideoUseCase(this.repository);

  Future<Either<Failure, VideoContent>> call(String chapterId) async {
    return await repository.generateVideo(chapterId);
  }
}
