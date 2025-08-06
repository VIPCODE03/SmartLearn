
import 'package:smart_learn/core/database/tables/table.dart';

class AssistantConversationTable extends Table {
  static AssistantConversationTable get instance => AssistantConversationTable();
  @override
  String get tableName => 'assistant_conversation';
  String get columnId => 'id';
  String get columnTitle => 'title';
  String get columnUpdateLast => 'updateLast';

  @override
  String get build => '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnTitle TEXT NOT NULL,
      $columnUpdateLast TEXT NOT NULL
      );
  ''';
}

class AssistantMessageTable extends Table {
  static AssistantMessageTable get instance => AssistantMessageTable();
  @override
  String get tableName => 'assistant_message';
  String get columnId => 'id';
  String get columnConversationId => 'conversationId';
  String get columnRole => 'role';
  String get columnContent => 'content';
  String get columnCreatedAt => 'createdAt';

  @override
  String get build => '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnConversationId TEXT NOT NULL,
      $columnRole TEXT NOT NULL,
      $columnContent TEXT NOT NULL,
      $columnCreatedAt TEXT NOT NULL,
      
      FOREIGN KEY ($columnConversationId) REFERENCES ${AssistantConversationTable.instance.tableName} (${AssistantConversationTable.instance.columnId}) ON DELETE CASCADE
    );
  ''';
}