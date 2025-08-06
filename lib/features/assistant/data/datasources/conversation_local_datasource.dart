
import 'package:smart_learn/core/database/appdatabase.dart';
import 'package:smart_learn/core/database/tables/assistant_table.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/features/assistant/data/models/conversation_model.dart';

abstract class LDSConversation {
  Future<bool> add(MODConversation conversation);
  Future<bool> update(MODConversation conversation);
  Future<bool> delete(String id);
  Future<List<MODConversation>> getAll();
  Future<MODConversation> get(String id);
}

class LDSConversationImpl extends LDSConversation {
  final _appDatabase = AppDatabase.instance;
  final _table = AssistantConversationTable.instance;

  @override
  Future<bool> add(MODConversation conversation) async {
    final db = await _appDatabase.db;
    final result = await db.insert(
        _table.tableName,
        conversation.toMap()
    );

    return result > 0;
  }

  @override
  Future<bool> update(MODConversation conversation) async {
    final db = await _appDatabase.db;
    final result = await db.update(
      _table.tableName,
      conversation.toMap(),
      where: '${_table.columnId} = ?',
      whereArgs: [conversation.id],
    );
    return result > 0;
  }

  @override
  Future<bool> delete(String id) async {
    final db = await _appDatabase.db;
    final result = await db.delete(
      _table.tableName,
      where: '${_table.columnId} = ?',
      whereArgs: [id],
    );
    return result > 0;
  }

  @override
  Future<MODConversation> get(String id) async {
    final db = await _appDatabase.db;
    final maps = await db.query(
      _table.tableName,
      where: '${_table.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Conversation not found');
    }

    return MODConversation.fromJson(maps.first);
  }

  @override
  Future<List<MODConversation>> getAll() async {
    final db = await _appDatabase.db;
    final maps = await db.query(
      _table.tableName,
      orderBy: '${_table.columnUpdateLast} DESC',
    );

    return maps.map((json) => MODConversation.fromJson(json)).toList();
  }
}
