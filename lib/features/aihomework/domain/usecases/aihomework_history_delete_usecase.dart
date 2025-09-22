
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/aihomework/domain/parameters/aihomework_history_params.dart';
import 'package:smart_learn/features/aihomework/domain/repositories/aihomework_repository.dart';

class UCEAIHomeWorkHistoryDelete extends UseCase<bool, PARAIHomeWorkHistoryDelete> {
  final REPAIHomeWorkHistory _repository;
  UCEAIHomeWorkHistoryDelete(this._repository);

  @override
  Future<Either<Failure, bool>> call(PARAIHomeWorkHistoryDelete params) {
    return _repository.delete(params.id);
  }
}