import 'package:smart_learn/core/database/tables/file_table.dart';
import 'package:smart_learn/core/database/tables/table.dart';

class QuizTable extends Table {
  static QuizTable get instance => QuizTable();
  @override
  String get tableName      => 'quiztable';
  String get columnId       => 'id';
  String get columnQuestion => 'question';
  String get columnAnswers  => 'answers';
  String get columnTag      => 'tag';

  //- Các thuộc tính con  -
  String get columnChildProperties => 'childProperties';

  //- Các khóa ngoại  -
  String get columnForeignFile => 'fileId';

  @override
  String get build => '''
    CREATE TABLE $tableName (
      $columnId       TEXT PRIMARY KEY,
      $columnQuestion TEXT NOT NULL,
      $columnAnswers  TEXT NOT NULL,
      $columnTag      TEXT NOT NULL,
      $columnChildProperties TEXT,
      
      $columnForeignFile TEXT,
      FOREIGN KEY ($columnForeignFile) REFERENCES ${FileTable.instance.tableName}(${FileTable.instance.columnId}) ON DELETE CASCADE
      );
  ''';
}

class QuizLinkTable extends TableLink {
  static QuizLinkTable get instance => QuizLinkTable();

  @override
  String get tableName => 'quizlinktable';
}