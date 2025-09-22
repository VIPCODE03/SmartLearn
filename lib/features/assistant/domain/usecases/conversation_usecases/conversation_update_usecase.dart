import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/assistant/domain/entities/converstation_entity.dart';
import 'package:smart_learn/features/assistant/domain/parameters/conversation_params.dart';
import '../../repositories/conversation_repository.dart';

class UCEConversationUpdate extends UseCase<ENTConversation, ConversationUpdateParams> {
  final REPConversation repository;
  UCEConversationUpdate(this.repository);

  @override
  Future<Either<Failure, ENTConversation>> call(ConversationUpdateParams params) async {
    final conversation = ENTConversation(
      id: params.conversation.id,
      title: params.name ?? params.conversation.title,
      updateLast: DateTime.now()
    );
    final result = await repository.update(conversation);
    return result.fold(
            (failure) => Left(failure),
            (completed) => completed
            ? Right(conversation)
            : Left(CacheFailure())
    );
  }
}