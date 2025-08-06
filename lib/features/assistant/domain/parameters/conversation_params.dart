
import 'package:smart_learn/features/assistant/domain/entities/converstation_entity.dart';

class ConversationAddParams {
  final String name;
  ConversationAddParams({required this.name});
}

class ConversationUpdateParams {
  final ENTConversation conversation;
  final String? name;
  ConversationUpdateParams(this.conversation, {this.name});
}

class ConversationDeleteParams {
  final String id;
  ConversationDeleteParams(this.id);
}

class ConversationGetParams {}

class ConversationGetAllParams extends ConversationGetParams {}