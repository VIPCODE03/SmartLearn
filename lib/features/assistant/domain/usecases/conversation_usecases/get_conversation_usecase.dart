import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/assistant/domain/entities/converstation_entity.dart';
import 'package:smart_learn/features/assistant/domain/parameters/conversation_params.dart';
import '../../repositories/conversation_repository.dart';

class UCEConversationGet extends UseCase<List<ENTConversation>, ConversationGetParams> {
  final REPConversation repository;
  UCEConversationGet(this.repository);

  @override
  Future<Either<Failure, List<ENTConversation>>> call(ConversationGetParams params) async {
    switch(params) {
      case ConversationGetAllParams _:
        return repository.getAll();

      default:
        logError('Invalid params', context: 'UCEGetConversation');
        throw UnimplementedError();
    }
  }
}