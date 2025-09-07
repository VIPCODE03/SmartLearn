import 'package:smart_learn/core/database/tables/table.dart';

class SubjectTable extends Table {
  static SubjectTable get instance => SubjectTable();

  @override
  String get tableName => 'subjecttable';
  String get columnId      => 'id';
  String get columnName    => 'name';
  String get columnLastStudyDate  => 'lastStudyDate';
  String get columnTags  => 'tags';
  String get columnLevel  => 'level';
  String get columnExercisesScores  => 'exercisesScores';

  @override
  String get build => '''
    CREATE TABLE $tableName (
      $columnId      TEXT PRIMARY KEY,
      $columnName    TEXT NOT NULL,
      $columnLastStudyDate  TEXT,
      $columnTags  TEXT,
      $columnLevel  TEXT NOT NULL,
      $columnExercisesScores  TEXT
      );
    ''';
}