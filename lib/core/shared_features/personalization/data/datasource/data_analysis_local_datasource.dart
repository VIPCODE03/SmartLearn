import 'package:smart_learn/core/database/appdatabase.dart';
import 'package:smart_learn/core/database/tables/dataanalysis_table.dart';
import 'package:smart_learn/core/shared_features/personalization/data/models/data_analysis_model.dart';

abstract class LDSDataAnalysis {
  Future<bool> add(MODDataAnalysis model);
  Future<bool> update(MODDataAnalysis model);
  Future<bool> delete(String id);
  Future<bool> deleteAll();
  Future<bool> deleteByTag(String tag);
  Future<bool> deleteByOwnerId(String ownerId);

  Future<List<MODDataAnalysis>> getAll();
  Future<MODDataAnalysis?> getById(String id);
  Future<List<MODDataAnalysis>> getByTag(String tag);
  Future<MODDataAnalysis?> getByOwnerId(String ownerId);
}

class LDSDataAnalysisImpl extends LDSDataAnalysis {
  final _database = AppDatabase.instance;
  final _table = DataAnalysisTable.instance;

  @override
  Future<bool> add(MODDataAnalysis model) async {
    final db = await _database.db;
    final result = await db.insert(_table.tableName, model.toJson());
    return result > 0;
  }

  @override
  Future<bool> update(MODDataAnalysis model) async {
    final db = await _database.db;
    final result = await db.update(
      _table.tableName,
      model.toJson(),
      where: '${_table.columnId} = ?',
      whereArgs: [model.id],
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
  Future<bool> deleteAll() async {
    final db = await _database.db;
    final result = await db.delete(_table.tableName);
    return result > 0;
  }

  @override
  Future<bool> deleteByOwnerId(String ownerId) async {
    final db = await _database.db;
    final result = await db.delete(
      _table.tableName,
      where: '${_table.columnOwnerId} = ?',
      whereArgs: [ownerId],
    );
    return result > 0;
  }

  @override
  Future<bool> deleteByTag(String tag) async {
    final db = await _database.db;
    final result = await db.delete(
      _table.tableName,
      where: '${_table.columnTag} = ?',
      whereArgs: [tag],
    );
    return result > 0;
  }

  @override
  Future<List<MODDataAnalysis>> getAll() async {
    final db = await _database.db;
    final result = await db.query(_table.tableName);
    return result.map((e) => MODDataAnalysis.fromJson(e)).toList();
  }

  @override
  Future<MODDataAnalysis?> getById(String id) async {
    final db = await _database.db;
    final result = await db.query(
      _table.tableName,
      where: '${_table.columnId} = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return MODDataAnalysis.fromJson(result.first);
  }

  @override
  Future<MODDataAnalysis?> getByOwnerId(String ownerId) async {
    final db = await _database.db;
    final result = await db.query(
      _table.tableName,
      where: '${_table.columnOwnerId} = ?',
      whereArgs: [ownerId],
    );
    if (result.isEmpty) return null;
    return MODDataAnalysis.fromJson(result.first);
  }

  @override
  Future<List<MODDataAnalysis>> getByTag(String tag) async {
    final db = await _database.db;
    final result = await db.query(
      _table.tableName,
      where: '${_table.columnTag} = ?',
      whereArgs: [tag],
    );
    return result.map((e) => MODDataAnalysis.fromJson(e)).toList();
  }
}