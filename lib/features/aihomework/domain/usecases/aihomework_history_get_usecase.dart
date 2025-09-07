import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/aihomework/domain/entities/aihomework_history_entity.dart';
import 'package:smart_learn/features/aihomework/domain/parameters/aihomework_history_params.dart';
import 'package:smart_learn/features/aihomework/domain/repositories/aihomework_repository.dart';

class UCEAIHomeWorkHistoryGet extends UseCase<List<ENTAIHomeWorkHistory>, PARAIHomeWorkHistoryGet> {
  final REPAIHomeWorkHistory _repository;
  UCEAIHomeWorkHistoryGet(this._repository);

  @override
  Future<Either<Failure, List<ENTAIHomeWorkHistory>>> call(PARAIHomeWorkHistoryGet params) {
    switch(params) {
      case PARAIHomeWorkHistoryGetAll():
        return _repository.getAll();
      default:
        throw UnimplementedError();
    }
  }
}