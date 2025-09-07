import 'package:smart_learn/core/database/appdatabase.dart';
import 'package:smart_learn/core/database/tables/flashcard_table.dart';
import 'package:smart_learn/features/flashcard/data/models/flashcardset_model.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';

abstract class LDSFlashCardSet {
  Future<bool> add(MODFlashCardSet flashcardSet, {required FlashCardSetForeignParams foreignParams});
  Future<bool> update(MODFlashCardSet flashcardSet);
  Future<bool> delete(String id);

  Future<List<MODFlashCardSet>> getAll({required FlashCardSetForeignParams foreignParams});
  Future<MODFlashCardSet?> get(String id);
  Future<MODFlashCardSet?> getByExtenal({required FlashCardSetForeignParams foreignParams});
}

class LDSFlashCardSetImpl extends LDSFlashCardSet {
  final _table = FlashcardSetTable.instance;
  final _database = AppDatabase.instance;

  @override
  Future<bool> add(MODFlashCardSet flashcardSet, {required FlashCardSetForeignParams foreignParams}) async {
    final db = await _database.db;
    final result = await db.insert(
      _table.tableName,
      {
        ...flashcardSet.toMap(),
        _table.columnFileId: foreignParams.fileId,
      },
    );
    return result > 0;
  }

  @override
  Future<bool> update(MODFlashCardSet flashcardSet) async {
    final db = await _database.db;
    final result = await db.update(
      _table.tableName,
      flashcardSet.toMap(),
      where: '${_table.columnId} = ?',
      whereArgs: [flashcardSet.id],
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
  Future<List<MODFlashCardSet>> getAll({required FlashCardSetForeignParams foreignParams}) async {
    final db = await _database.db;
    final result = await db.query(_table.tableName);
    return result.map((e) => MODFlashCardSet.fromMap(e)).toList();
  }

  @override
  Future<MODFlashCardSet?> get(String id) async {
    final db = await _database.db;
    final result = await db.query(
      _table.tableName,
      where: '${_table.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return MODFlashCardSet.fromMap(result.first);
  }

  @override
  Future<MODFlashCardSet?> getByExtenal({required FlashCardSetForeignParams foreignParams}) async {
    final db = await _database.db;
    if(foreignParams.fileId != null) {
      final result = await db.query(
        _table.tableName,
        where: '${_table.columnFileId} = ?',
        whereArgs: [foreignParams.fileId],
        limit: 1,
      );
      if (result.isEmpty) return null;
      return MODFlashCardSet.fromMap(result.first);
    }
    return null;
  }
}