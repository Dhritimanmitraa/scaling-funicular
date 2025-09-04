import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/video_content.dart';
import '../repositories/content_repository.dart';

class GetVideoUseCase {
  final ContentRepository repository;

  GetVideoUseCase(this.repository);

  Future<Either<Failure, VideoContent>> call(String chapterId) async {
    return await repository.getVideo(chapterId);
  }
}
