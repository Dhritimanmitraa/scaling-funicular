import 'dart:convert';
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
    var data = response.data;
    if (data is String) {
      try { data = json.decode(data); } catch (_) {}
    }
    final List<dynamic> boardsData =
        (data is List) ? data : (data['boards'] as List? ?? const []);
    return boardsData
        .map((board) {
          final map = board as Map<String, dynamic>;
          return BoardModel(id: (map['id']).toString(), name: map['name'] as String);
        })
        .toList();
  }

  @override
  Future<List<ClassModel>> getClasses(String boardId) async {
    final response = await apiClient.get(
      AppConstants.classesEndpoint,
      queryParameters: {'board_id': boardId},
    );
    var data = response.data;
    if (data is String) {
      try { data = json.decode(data); } catch (_) {}
    }
    final List<dynamic> classesData =
        (data is List) ? data : (data['classes'] as List? ?? const []);
    return classesData.map((classData) {
      final map = classData as Map<String, dynamic>;
      final idStr = (map['id']).toString();
      final name = map['name'] as String? ?? '';
      final match = RegExp(r'\d+').firstMatch(name);
      final classNum = int.tryParse(match?.group(0) ?? '') ?? int.tryParse(idStr) ?? 0;
      return ClassModel(id: idStr, boardId: boardId, classNumber: classNum);
    }).toList();
  }

  @override
  Future<List<SubjectModel>> getSubjects(String classId) async {
    final response = await apiClient.get(
      AppConstants.subjectsEndpoint,
      queryParameters: {'class_id': classId},
    );
    var data = response.data;
    if (data is String) {
      try { data = json.decode(data); } catch (_) {}
    }
    final List<dynamic> subjectsData =
        (data is List) ? data : (data['subjects'] as List? ?? const []);
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
    var data = response.data;
    if (data is String) {
      try { data = json.decode(data); } catch (_) {}
    }
    final List<dynamic> chaptersData =
        (data is List) ? data : (data['chapters'] as List? ?? const []);
    return chaptersData
        .map((chapter) => ChapterModel.fromJson(chapter as Map<String, dynamic>))
        .toList();
  }
}
