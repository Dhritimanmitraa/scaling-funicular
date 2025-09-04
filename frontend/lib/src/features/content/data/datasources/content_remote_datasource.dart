import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/models/content_model.dart';
import '../models/video_content_model.dart';

abstract class ContentRemoteDataSource {
  Future<VideoContentModel> getVideo(String chapterId);
  Future<ContentModel> getQuiz(String chapterId);
  Future<void> submitQuiz(String quizId, Map<String, dynamic> answers);
  Future<void> markVideoCompleted(String videoId, String userId);
  Future<VideoContentModel> generateVideo(String chapterId);
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final ApiClient apiClient;

  ContentRemoteDataSourceImpl(this.apiClient);

  @override
  Future<VideoContentModel> getVideo(String chapterId) async {
    final response = await apiClient.get(
      '${AppConstants.videoEndpoint}/$chapterId',
    );

    final contentData = response.data;
    if (contentData['content_type'] == 'video') {
      return VideoContentModel.fromContentData(
        contentData['id'],
        chapterId,
        contentData['content_data'],
        DateTime.parse(contentData['created_at']),
      );
    } else {
      throw Exception('Invalid content type');
    }
  }

  @override
  Future<VideoContentModel> generateVideo(String chapterId) async {
    final response = await apiClient.post(
      '${AppConstants.videoEndpoint}/generate',
      data: {'chapter_id': chapterId},
    );

    final contentData = response.data;
    return VideoContentModel.fromContentData(
      contentData['id'],
      chapterId,
      contentData['content_data'],
      DateTime.parse(contentData['created_at']),
    );
  }

  @override
  Future<ContentModel> getQuiz(String chapterId) async {
    final response = await apiClient.get(
      '${AppConstants.quizEndpoint}/$chapterId',
    );

    return ContentModel.fromJson(response.data);
  }

  @override
  Future<void> submitQuiz(String quizId, Map<String, dynamic> answers) async {
    await apiClient.post(
      '${AppConstants.quizEndpoint}/$quizId/submit',
      data: {'answers': answers},
    );
  }

  @override
  Future<void> markVideoCompleted(String videoId, String userId) async {
    await apiClient.post(
      AppConstants.progressEndpoint,
      data: {
        'content_id': videoId,
        'user_id': userId,
        'status': 'completed',
      },
    );
  }
}
