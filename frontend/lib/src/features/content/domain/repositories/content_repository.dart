import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/content_model.dart';
import '../entities/video_content.dart';

abstract class ContentRepository {
  Future<Either<Failure, VideoContent>> getVideo(String chapterId);
  Future<Either<Failure, ContentModel>> getQuiz(String chapterId);
  Future<Either<Failure, void>> submitQuiz(String quizId, Map<String, dynamic> answers);
  Future<Either<Failure, void>> markVideoCompleted(String videoId, String userId);
  Future<Either<Failure, VideoContent>> generateVideo(String chapterId);
}
