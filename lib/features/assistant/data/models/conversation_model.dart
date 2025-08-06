import 'package:smart_learn/core/database/tables/assistant_table.dart';
import 'package:smart_learn/features/assistant/domain/entities/converstation_entity.dart';

AssistantConversationTable get _table => AssistantConversationTable.instance;

class MODConversation extends ENTConversation {
  const MODConversation({
    required super.id,
    required super.title,
    required super.updateLast,
  });

  factory MODConversation.fromEntity(ENTConversation entity) {
    return MODConversation(
      id: entity.id,
      title: entity.title,
      updateLast: entity.updateLast,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      _table.columnId: id,
      _table.columnTitle: title,
      _table.columnUpdateLast: updateLast.toIso8601String(),
    };
  }

  factory MODConversation.fromJson(Map<String, dynamic> json) {
    return MODConversation(
      id: json[_table.columnId] as String,
      title: json[_table.columnTitle] as String,
      updateLast: DateTime.parse(json[_table.columnUpdateLast] as String),
    );
  }
}
