import 'package:smart_learn/core/database/tables/file_table.dart';
import 'package:smart_learn/core/database/tables/table.dart';

class FlashcardSetTable extends Table {
  static FlashcardSetTable get instance => FlashcardSetTable();
  @override
  String get tableName => 'flashcardsettable';

  String get columnId      => 'id';
  String get columnName    => 'name';
  String get columnIsSelect=> 'isSelect';

  //- Khóa ngoại  -
  String get columnFileId  => 'fileId';

  @override
  String get build => '''
    CREATE TABLE $tableName (
      $columnId       TEXT PRIMARY KEY,
      $columnName     TEXT NOT NULL,
      $columnIsSelect INTEGER DEFAULT 0,
      
      $columnFileId   TEXT UNIQUE,     
      FOREIGN KEY($columnFileId) REFERENCES ${FileTable.instance.tableName}(${FileTable.instance.columnId}) ON DELETE CASCADE
    );
  ''';
}

/// Bảng FlashCardTable
class FlashCardTable extends Table {
  static FlashCardTable get instance => FlashCardTable();
  @override
  String get tableName => 'flashcardtable';
  String get columnId      => 'id';
  String get columnCardSetId   => 'flashCardSetId';
  String get columnFront => 'front';
  String get columnBack  => 'back';
  String get columnRememberLevel => 'rememberLevel';

  @override
  String get build => '''
    CREATE TABLE $tableName (
      $columnId      TEXT PRIMARY KEY,
      $columnCardSetId   TEXT NOT NULL,
      $columnFront TEXT NOT NULL,
      $columnBack  TEXT NOT NULL,
      $columnRememberLevel INTEGER DEFAULT 0,
      
      FOREIGN KEY($columnCardSetId) REFERENCES ${FlashcardSetTable.instance.tableName}(${FlashcardSetTable.instance.columnId}) ON DELETE CASCADE
    );
  ''';
}