
import 'package:smart_learn/core/database/appdatabase.dart';
import 'package:smart_learn/core/database/tables/aihomework_table.dart';
import 'package:smart_learn/features/aihomework/data/models/aihomework_model.dart';

abstract class LDSAIHomeWorkHistory {
  Future<bool> add(MODAIHomeWorkHistory history);
  Future<bool> update(MODAIHomeWorkHistory history);
  Future<bool> delete(String id);
  Future<List<MODAIHomeWorkHistory>> getAll();
}

class LDSAIHomeWorkHistoryImpl extends LDSAIHomeWorkHistory {
  final _database = AppDatabase.instance;
  final _table = AIHomeWorkTable.instance;

  @override
  Future<bool> add(MODAIHomeWorkHistory history) async {
    final db = await _database.db;
    final result = await db.insert(
        _table.tableName,
        history.toJson()
    );
    return result > 0;
  }

  @override
  Future<bool> update(MODAIHomeWorkHistory history) async {
    final db = await _database.db;
    final result = await db.update(
      _table.tableName,
      history.toJson(),
      where: '${_table.columnId} = ?',
      whereArgs: [history.id],
    );
    return result > 0;
  }


  @override
  Future<bool> delete(String id) async {
    final db = await _database.db;
    final result = await db.delete(
        _table.tableName,
        where: '${_table.columnId} = ?',
        whereArgs: [id]
    );
    return result > 0;
  }

  @override
  Future<List<MODAIHomeWorkHistory>> getAll() async {
    final db = await _database.db;
    final result = await db.query(
        _table.tableName,
        orderBy: '${_table.columnCreatedAt} DESC'
    );
    return result.map((json) => MODAIHomeWorkHistory.fromJson(json)).toList();
  }
}