import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/models/board_model.dart';
import '../../../../core/models/class_model.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../core/models/chapter_model.dart';

abstract class CurriculumRemoteDataSource {
  Future<List<BoardModel>> getBoards();
  Future<List<ClassModel>> getClasses(String boardId);
  Future<List<SubjectModel>> getSubjects(String classId);
  Future<List<ChapterModel>> getChapters(String subjectId);
}

class CurriculumRemoteDataSourceImpl implements CurriculumRemoteDataSource {
  final ApiClient apiClient;

  CurriculumRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<BoardModel>> getBoards() async {
    final response = await apiClient.get(AppConstants.boardsEndpoint);
    
    final List<dynamic> boardsData = response.data['boards'] ?? response.data;
    return boardsData
        .map((board) => BoardModel.fromJson(board as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ClassModel>> getClasses(String boardId) async {
    final response = await apiClient.get(
      AppConstants.classesEndpoint,
      queryParameters: {'board_id': boardId},
    );
    
    final List<dynamic> classesData = response.data['classes'] ?? response.data;
    return classesData
        .map((classData) => ClassModel.fromJson(classData as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<SubjectModel>> getSubjects(String classId) async {
    final response = await apiClient.get(
      AppConstants.subjectsEndpoint,
      queryParameters: {'class_id': classId},
    );
    
    final List<dynamic> subjectsData = response.data['subjects'] ?? response.data;
    return subjectsData
        .map((subject) => SubjectModel.fromJson(subject as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ChapterModel>> getChapters(String subjectId) async {
    final response = await apiClient.get(
      AppConstants.chaptersEndpoint,
      queryParameters: {'subject_id': subjectId},
    );
    
    final List<dynamic> chaptersData = response.data['chapters'] ?? response.data;
    return chaptersData
        .map((chapter) => ChapterModel.fromJson(chapter as Map<String, dynamic>))
        .toList();
  }
}
