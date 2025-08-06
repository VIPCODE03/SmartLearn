import 'package:smart_learn/core/database/tables/quiz_table.dart';
import 'package:smart_learn/features/quiz/data/models/a_quiz_model.dart';
import 'package:smart_learn/core/database/appdatabase.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_params.dart';

abstract class LDSQuiz {
  Future<bool> add(MODQuiz quiz, {required ForeignKeyParams foreign});
  Future<bool> update(MODQuiz quiz);
  Future<bool> delete(String id);

  Future<ENTQuiz?> getById(String id);
  Future<List<ENTQuiz>> getAll({required ForeignKeyParams foreign});
}

class LDSQuizImpl extends LDSQuiz {
  final _database = AppDatabase.instance;
  final _table = QuizTable.instance;

  @override
  Future<bool> add(MODQuiz quiz, {required ForeignKeyParams foreign}) async {
    final db = await _database.db;
    final result = await db.insert(
        _table.tableName,
        {
          ...quiz.toMap(),
          _table.columnForeignFile: foreign.fileId,
        });
    return result > 0;
  }

  @override
  Future<bool> update(MODQuiz quiz) async {
    final db = await _database.db;
    final result = await db.update(
      _table.tableName,
      quiz.toMap(),
      where: '${_table.columnId} = ?',
      whereArgs: [quiz.id],
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
  Future<ENTQuiz?> getById(String id) async {
    final db = await _database.db;
    final result = await db.query(
      _table.tableName,
      where: '${_table.columnId} = ?',
      whereArgs: [id],
    );
    if (result.isEmpty) return null;
    return MODQuiz.fromMap(result.first);
  }

  @override
  Future<List<MODQuiz>> getAll({required ForeignKeyParams foreign}) async {
    final db = await _database.db;
    final result = await db.query(
      _table.tableName,
      where: '${_table.columnForeignFile} = ?',
      whereArgs: [foreign.fileId],
    );
    return result.map((e) => MODQuiz.fromMap(e)).toList();
  }
}
