import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/board_model.dart';
import '../repositories/curriculum_repository.dart';

class GetBoardsUseCase {
  final CurriculumRepository repository;

  GetBoardsUseCase(this.repository);

  Future<Either<Failure, List<BoardModel>>> call() async {
    return await repository.getBoards();
  }
}
