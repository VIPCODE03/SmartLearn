import 'package:smart_learn/core/database/tables/table.dart';

class SubjectTable extends Table {
  static SubjectTable get instance => SubjectTable();

  @override
  String get tableName => 'subjecttable';
  String get columnId      => 'id';
  String get columnName    => 'name';
  String get columnLastStudyDate  => 'lastStudyDate';
  String get columnLevel  => 'level';
  String get columnIsHide  => 'isHide';

  @override
  String get build => '''
    CREATE TABLE $tableName (
      $columnId      TEXT PRIMARY KEY,
      $columnName    TEXT NOT NULL,
      $columnLastStudyDate  TEXT,
      $columnLevel  TEXT NOT NULL,
      $columnIsHide  INTEGER DEFAULT 0
      );
    ''';
}