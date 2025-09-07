
import 'package:smart_learn/core/database/appdatabase.dart';
import 'package:smart_learn/core/database/tables/file_table.dart';
import 'package:smart_learn/features/file/data/models/appfile_model.dart';
import 'package:smart_learn/features/file/domain/parameters/file_params.dart';

abstract class LDSAppFile {
  Future<MODAppFile> createFile(MODAppFile file, {required FileExtenalValue extenalValue});
  Future<MODAppFile> updateFile(MODAppFile file);
  Future<bool> deleteFile(String id);
  Future<bool> deleteFiles(String pathId);

  Future<List<MODAppFile>> getFiles(String pathId, {required FileExtenalValue extenalValue});
  Future<MODAppFile?> getFile(String id);
  Future<MODAppFile?> getFileByPathName(String pathId, String name, {required FileExtenalValue extenalValue});
}

class LDSAppFileImpl extends LDSAppFile {
  final _database = AppDatabase.instance;
  final FileTable _table = FileTable.instance;

  @override
  Future<MODAppFile> createFile(MODAppFile file, {required FileExtenalValue extenalValue}) async {
    final db = await _database.db;
    final data = file.toJson();
    data[_table.columnSubjectId] = extenalValue.subjectId;
    data[_table.columnPartition] = extenalValue.partition;

    if(file.pathId == 'root') {
      data[_table.columnPathId] = null;
    }
    await db.insert(_table.tableName, data);
    return file;
  }

  @override
  Future<MODAppFile> updateFile(MODAppFile file) async {
    final db = await _database.db;
    final data = file.toJson();
    if(file.pathId == 'root') {
      data[_table.columnPathId] = null;
    }
    await db.update(
      _table.tableName,
      data,
      where: '${_table.columnId} = ?',
      whereArgs: [file.id],
    );
    return file;
  }

  @override
  Future<bool> deleteFile(String id) async {
    final db = await _database.db;
    final count = await db.delete(
      _table.tableName,
      where: '${_table.columnId} = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  @override
  Future<bool> deleteFiles(String pathId) async {
    final db = await _database.db;
    final count = await db.delete(
      _table.tableName,
      where: '${_table.columnPathId} = ?',
      whereArgs: [pathId],
    );
    return count > 0;
  }

  @override
  Future<List<MODAppFile>> getFiles(String pathId, {required FileExtenalValue extenalValue}) async {
    final db = await _database.db;

    final List<Map<String, Object?>> result;
    if(pathId == 'root') {
      result = await db.query(
        _table.tableName,
        where: '${_table.columnSubjectId} = ? AND ${_table.columnPartition} = ? AND ${_table.columnPathId} IS NULL',
        whereArgs: [extenalValue.subjectId, extenalValue.partition],
      );
    }
    else {
      result = await db.query(
        _table.tableName,
        where: '${_table.columnPathId} = ? AND ${_table.columnSubjectId} = ?',
        whereArgs: [pathId, extenalValue.subjectId],
      );
    }

    return result.map((e) => MODAppFile.fromJson(e)).toList();
  }

  @override
  Future<MODAppFile?> getFile(String id) async {
    final db = await _database.db;
    final result = await db.query(
      _table.tableName,
      where: '${_table.columnId} = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return MODAppFile.fromJson(result.first);
  }

  @override
  Future<MODAppFile?> getFileByPathName(String pathId, String name, {required FileExtenalValue extenalValue}) async {
    final db = await _database.db;
    final result = await db.query(
      _table.tableName,
      where: '${_table.columnPathId} = ? AND ${_table.columnName} = ? AND ${_table.columnSubjectId} = ?',
      whereArgs: [pathId, name, extenalValue.subjectId],
    );
    if (result.isEmpty) return null;
    return MODAppFile.fromJson(result.first);
  }
}