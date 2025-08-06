import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/assistant/domain/entities/content_entity.dart';
import 'package:smart_learn/features/assistant/domain/parameters/mess_params.dart';
import 'package:smart_learn/features/assistant/domain/repositories/message_repository.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

class UCEMessAdd extends UseCase<ENTMessage, MessAddParams> {
  final REPMessage _repository;
  UCEMessAdd(this._repository);

  @override
  Future<Either<Failure, ENTMessage>> call(MessAddParams params) async {
    final newMess = ENTMessage(
        UTIGenerateID.random(),
        params.role,
        params.content,
        createdAt: DateTime.now()
    );
    final result = await _repository.add(newMess, foreign: params.foreign);
    return result.fold(
            (failure) => Left(failure),
            (success) => success ? Right(newMess) : Left(CacheFailure())
    );
  }
}