import 'package:smart_learn/core/database/appdatabase.dart';
import 'package:smart_learn/core/database/tables/assistant_table.dart';
import 'package:smart_learn/features/assistant/data/models/content_model.dart';
import 'package:smart_learn/features/assistant/domain/parameters/mess_params.dart';

abstract class LDSMessage {
  Future<bool> add(MODMessage message, {required MessForeignParams foreign});
  Future<bool> delete(String id);
  Future<List<MODMessage>> getMessages({required MessForeignParams foreign});
}

class LDSMessageImpl extends LDSMessage {
  final _db = AppDatabase.instance;
  final _table = AssistantMessageTable.instance;

  @override
  Future<bool> add(MODMessage message, {required MessForeignParams foreign}) async {
    final db = await _db.db;
    final result = await db.insert(
        _table.tableName,
        {
          ...message.toMap(),
          _table.columnConversationId: foreign.convertationId
        });
    return result > 0;
  }

  @override
  Future<bool> delete(String id) async {
    final db = await _db.db;
    final result = await db.delete(
      _table.tableName,
      where: '${_table.columnId} = ?',
      whereArgs: [id],
    );
    return result > 0;
  }

  @override
  Future<List<MODMessage>> getMessages({required MessForeignParams foreign}) async {
    final db = await _db.db;

    final maps = await db.query(
      _table.tableName,
      where: '${_table.columnConversationId} = ?',
      whereArgs: [foreign.convertationId],
      orderBy: '${_table.columnCreatedAt} ASC',
    );

    return maps.map((e) => MODMessage.fromMap(e)).toList();
  }
}

