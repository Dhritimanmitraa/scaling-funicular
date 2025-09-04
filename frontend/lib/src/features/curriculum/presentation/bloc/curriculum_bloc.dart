import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/curriculum_repository.dart';
import 'curriculum_event.dart';
import 'curriculum_state.dart';

class CurriculumBloc extends Bloc<CurriculumEvent, CurriculumState> {
  final CurriculumRepository curriculumService;

  CurriculumBloc({required this.curriculumService}) 
      : super(const CurriculumInitial()) {
    on<CurriculumBoardsRequested>(_onBoardsRequested);
    on<CurriculumClassesRequested>(_onClassesRequested);
    on<CurriculumSubjectsRequested>(_onSubjectsRequested);
    on<CurriculumChaptersRequested>(_onChaptersRequested);
    on<CurriculumReset>(_onReset);
  }

  Future<void> _onBoardsRequested(
    CurriculumBoardsRequested event,
    Emitter<CurriculumState> emit,
  ) async {
    emit(const CurriculumLoading());

    final result = await curriculumService.getBoards();
    result.fold(
      (failure) => emit(CurriculumError(message: failure.message)),
      (boards) => emit(CurriculumBoardsLoaded(boards: boards)),
    );
  }

  Future<void> _onClassesRequested(
    CurriculumClassesRequested event,
    Emitter<CurriculumState> emit,
  ) async {
    emit(const CurriculumLoading());

    final result = await curriculumService.getClasses(event.boardId);
    result.fold(
      (failure) => emit(CurriculumError(message: failure.message)),
      (classes) => emit(CurriculumClassesLoaded(
        classes: classes,
        boardId: event.boardId,
      )),
    );
  }

  Future<void> _onSubjectsRequested(
    CurriculumSubjectsRequested event,
    Emitter<CurriculumState> emit,
  ) async {
    emit(const CurriculumLoading());

    final result = await curriculumService.getSubjects(event.classId);
    result.fold(
      (failure) => emit(CurriculumError(message: failure.message)),
      (subjects) => emit(CurriculumSubjectsLoaded(
        subjects: subjects,
        classId: event.classId,
      )),
    );
  }

  Future<void> _onChaptersRequested(
    CurriculumChaptersRequested event,
    Emitter<CurriculumState> emit,
  ) async {
    emit(const CurriculumLoading());

    final result = await curriculumService.getChapters(event.subjectId);
    result.fold(
      (failure) => emit(CurriculumError(message: failure.message)),
      (chapters) => emit(CurriculumChaptersLoaded(
        chapters: chapters,
        subjectId: event.subjectId,
      )),
    );
  }

  void _onReset(
    CurriculumReset event,
    Emitter<CurriculumState> emit,
  ) {
    emit(const CurriculumInitial());
  }
}
