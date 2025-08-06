import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/assistant/domain/entities/converstation_entity.dart';
import 'package:smart_learn/features/assistant/domain/parameters/conversation_params.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

import '../../repositories/conversation_repository.dart';

class UCEConversationAdd extends UseCase<ENTConversation, ConversationAddParams> {
  final REPConversation repository;
  UCEConversationAdd(this.repository);

  @override
  Future<Either<Failure, ENTConversation>> call(ConversationAddParams params) async {
    final conversation = ENTConversation(
        id: UTIGenerateID.random(),
        title: params.name,
        updateLast: DateTime.now()
    );
    final result = await repository.add(conversation);
    return result.fold(
            (failure) => Left(failure),
            (completed) => completed
            ? Right(conversation)
            : Left(CacheFailure())
    );
  }
}