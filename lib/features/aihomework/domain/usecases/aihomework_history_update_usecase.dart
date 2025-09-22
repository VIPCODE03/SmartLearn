import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/aihomework/domain/entities/aihomework_history_entity.dart';
import 'package:smart_learn/features/aihomework/domain/parameters/aihomework_history_params.dart';
import 'package:smart_learn/features/aihomework/domain/repositories/aihomework_repository.dart';

class UCEAIHomeWorkHistoryUpdate extends UseCase<ENTAIHomeWorkHistory, PARAIHomeWorkHistoryUpdate> {
  final REPAIHomeWorkHistory _repository;
  UCEAIHomeWorkHistoryUpdate(this._repository);

  @override
  Future<Either<Failure, ENTAIHomeWorkHistory>> call(PARAIHomeWorkHistoryUpdate params) async {
    final updatedHistory = ENTAIHomeWorkHistory(
      id: params.history.id,
      textQuestion: params.textQuestion ?? params.history.textQuestion,
      imagePath: params.imagePath ?? params.history.imagePath,
      textAnswer: params.textAnswer ?? params.history.textAnswer,
      createdAt: params.history.createdAt,
    );
    final result = await _repository.update(updatedHistory);
    return result.fold(
      (failure) => Left(failure),
      (success) => success ? Right(updatedHistory) : Left(CacheFailure()),
    );
  }
}