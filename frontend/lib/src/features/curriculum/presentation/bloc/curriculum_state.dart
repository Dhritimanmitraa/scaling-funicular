import 'package:equatable/equatable.dart';
import '../../../../core/models/board_model.dart';
import '../../../../core/models/class_model.dart';
import '../../../../core/models/subject_model.dart';
import '../../../../core/models/chapter_model.dart';

abstract class CurriculumState extends Equatable {
  const CurriculumState();

  @override
  List<Object?> get props => [];
}

class CurriculumInitial extends CurriculumState {
  const CurriculumInitial();
}

class CurriculumLoading extends CurriculumState {
  const CurriculumLoading();
}

class CurriculumBoardsLoaded extends CurriculumState {
  final List<BoardModel> boards;

  const CurriculumBoardsLoaded({required this.boards});

  @override
  List<Object> get props => [boards];
}

class CurriculumClassesLoaded extends CurriculumState {
  final List<ClassModel> classes;
  final String boardId;

  const CurriculumClassesLoaded({
    required this.classes,
    required this.boardId,
  });

  @override
  List<Object> get props => [classes, boardId];
}

class CurriculumSubjectsLoaded extends CurriculumState {
  final List<SubjectModel> subjects;
  final String classId;

  const CurriculumSubjectsLoaded({
    required this.subjects,
    required this.classId,
  });

  @override
  List<Object> get props => [subjects, classId];
}

class CurriculumChaptersLoaded extends CurriculumState {
  final List<ChapterModel> chapters;
  final String subjectId;

  const CurriculumChaptersLoaded({
    required this.chapters,
    required this.subjectId,
  });

  @override
  List<Object> get props => [chapters, subjectId];
}

class CurriculumError extends CurriculumState {
  final String message;

  const CurriculumError({required this.message});

  @override
  List<Object> get props => [message];
}
