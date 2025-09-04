import 'package:equatable/equatable.dart';

abstract class CurriculumEvent extends Equatable {
  const CurriculumEvent();

  @override
  List<Object?> get props => [];
}

class CurriculumBoardsRequested extends CurriculumEvent {
  const CurriculumBoardsRequested();
}

class CurriculumClassesRequested extends CurriculumEvent {
  final String boardId;

  const CurriculumClassesRequested({required this.boardId});

  @override
  List<Object> get props => [boardId];
}

class CurriculumSubjectsRequested extends CurriculumEvent {
  final String classId;

  const CurriculumSubjectsRequested({required this.classId});

  @override
  List<Object> get props => [classId];
}

class CurriculumChaptersRequested extends CurriculumEvent {
  final String subjectId;

  const CurriculumChaptersRequested({required this.subjectId});

  @override
  List<Object> get props => [subjectId];
}

class CurriculumReset extends CurriculumEvent {
  const CurriculumReset();
}
