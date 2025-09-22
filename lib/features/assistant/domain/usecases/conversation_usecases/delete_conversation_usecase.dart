import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/assistant/domain/parameters/conversation_params.dart';
import 'package:smart_learn/features/assistant/domain/repositories/conversation_repository.dart';

class UCEConversationDelete extends UseCase<bool, ConversationDeleteParams> {
  final REPConversation repository;
  UCEConversationDelete(this.repository);

  @override
  Future<Either<Failure, bool>> call(ConversationDeleteParams params) {
    return repository.delete(params.id);
  }
}