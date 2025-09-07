import 'package:smart_learn/core/database/appdatabase.dart';
import 'package:smart_learn/core/database/tables/flashcard_table.dart';
import 'package:smart_learn/features/flashcard/data/models/flashcard_model.dart';

abstract class LDSFlashCard {
  Future<bool> add(MODFlashCard flashCard);
  Future<bool> update(MODFlashCard flashCard);
  Future<bool> multiReset(List<String> ids);
  Future<bool> delete(String id);
  Future<List<MODFlashCard>> getByCardSetId(String cardSetId);
}

class LDSFlashCardImpl extends LDSFlashCard {
  final FlashCardTable _table = FlashCardTable.instance;
  final AppDatabase _database = AppDatabase.instance;

  @override
  Future<bool> add(MODFlashCard flashCard) async {
    final db = await _database.db;
    final result = await db.insert(
      _table.tableName,
      flashCard.toMap(),
    );
    return result > 0;
  }

  @override
  Future<bool> update(MODFlashCard flashCard) async {
    final db = await _database.db;
    final result = await db.update(
      _table.tableName,
      flashCard.toMap(),
      where: '${_table.columnId} = ?',
      whereArgs: [flashCard.id],
    );
    return result > 0;
  }

  @override
  Future<bool> multiReset(List<String> ids) async {
    final db = await _database.db;

    final placeholders = List.filled(ids.length, '?').join(',');

    final result = await db.update(
      _table.tableName,
      {_table.columnRememberLevel: -1},
      where: '${_table.columnId} IN ($placeholders)',
      whereArgs: ids,
    );

    return result > 0;
  }


  @override
  Future<bool> delete(String id) async {
    final db = await _database.db;
    final result = await db.delete(
      _table.tableName,
      where: '${_table.columnId} = ?',
      whereArgs: [id],
    );
    return result > 0;
  }

  @override
  Future<List<MODFlashCard>> getByCardSetId(String cardSetId) async {
    final db = await _database.db;
    final result = await db.query(
      _table.tableName,
      where: '${_table.columnCardSetId} = ?',
      whereArgs: [cardSetId],
    );
    return result.map((e) => MODFlashCard.fromMap(e)).toList();
  }
}