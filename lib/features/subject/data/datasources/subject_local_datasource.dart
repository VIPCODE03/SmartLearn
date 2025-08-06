import 'package:smart_learn/core/database/appdatabase.dart';
import 'package:smart_learn/core/database/tables/subject_table.dart';
import 'package:smart_learn/features/subject/data/models/subject_model.dart';

abstract class LDSSubject {
  Future<bool> add(MODSubject subject);
  Future<bool> update(MODSubject subject);
  Future<bool> delete(String id);
  Future<List<MODSubject>> getAllSubject();
}

class LDSSubjectImpl implements LDSSubject {
  final _database = AppDatabase.instance;
  final _table = SubjectTable.instance;

  @override
  Future<bool> add(MODSubject subject) async {
    final db = await _database.db;
    final result = await db.insert(_table.tableName, subject.toMap());
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
  Future<List<MODSubject>> getAllSubject() async {
    final db = await _database.db;
    final result = await db.query(_table.tableName);
    return result.map((e) => MODSubject.fromMap(e)).toList();
  }

  @override
  Future<bool> update(MODSubject subject) async {
    final db = await _database.db;
    final result = await db.update(
      _table.tableName,
      subject.toMap(),
      where: '${_table.columnId} = ?',
    );
    return result > 0;
  }
}