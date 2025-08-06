import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/assistant/domain/entities/content_entity.dart';
import 'package:smart_learn/features/assistant/domain/parameters/mess_params.dart';
import 'package:smart_learn/features/assistant/domain/repositories/message_repository.dart';

class UCEMessGet extends UseCase<List<ENTMessage>, MessGetParams> {
  final REPMessage _repository;
  UCEMessGet(this._repository);

  @override
  Future<Either<Failure, List<ENTMessage>>> call(MessGetParams params) async {
    return await _repository.getMessages(foreign: params.foreign);
  }
}