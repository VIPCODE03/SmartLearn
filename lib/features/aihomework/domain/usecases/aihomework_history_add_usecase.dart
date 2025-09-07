import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/aihomework/domain/entities/aihomework_history_entity.dart';
import 'package:smart_learn/features/aihomework/domain/parameters/aihomework_history_params.dart';
import 'package:smart_learn/features/aihomework/domain/repositories/aihomework_repository.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

class UCEAIHomeWorkHistoryAdd extends UseCase<ENTAIHomeWorkHistory, PARAIHomeWorkHistoryAdd> {
  final REPAIHomeWorkHistory _repository;
  UCEAIHomeWorkHistoryAdd(this._repository);

  @override
  Future<Either<Failure, ENTAIHomeWorkHistory>> call(PARAIHomeWorkHistoryAdd params) async {
    final newHistory = ENTAIHomeWorkHistory(
      id: UTIGenerateID.random(),
      textQuestion: params.textQuestion,
      imagePath: params.imagePath,
      textAnswer: params.textAnswer,
      createdAt: DateTime.now(),
    );
    final result = await _repository.add(newHistory);
    return result.fold(
            (failure) => Left(failure),
            (success) => success ? Right(newHistory) : Left(CacheFailure()),
    );
  }
}