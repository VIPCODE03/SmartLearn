import 'package:smart_learn/core/database/tables/subject_table.dart';
import 'package:smart_learn/core/database/tables/table.dart';

class FileTable extends Table {
  static FileTable get instance => FileTable();

  @override
  String get tableName => 'filetable';

  String get columnId        => 'id';
  String get columnName      => 'name';
  String get columnPathId    => 'pathId';
  String get columnCreated   => 'createdAt';
  String get columnType      => 'type';
  String get columnPartition => 'partition';

  String get columnContent   => 'content';     // txt
  String get columnJson      => 'json';        // draw
  String get columnFilePath  => 'filePath';    // system

  //- Khóa ngoại  -
  String get columnSubjectId => 'subjectId';

  @override
  String get build => '''
    CREATE TABLE $tableName (
      $columnId        TEXT PRIMARY KEY,
      $columnName      TEXT NOT NULL,
      $columnPathId    TEXT,
      $columnCreated   TEXT NOT NULL,
      $columnType      TEXT NOT NULL,     
      $columnPartition TEXT NOT NULL,

      $columnContent   TEXT,
      $columnJson      TEXT,
      $columnFilePath  TEXT,
      
      $columnSubjectId TEXT NOT NULL,
      
     FOREIGN KEY ($columnPathId) REFERENCES $tableName($columnId) ON DELETE CASCADE,
     FOREIGN KEY ($columnSubjectId) REFERENCES ${SubjectTable.instance.tableName}(${SubjectTable.instance.columnId}) ON DELETE CASCADE
    );
  ''';
}