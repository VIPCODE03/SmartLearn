import 'package:smart_learn/core/database/tables/table.dart';

class UserTable extends Table {
  static UserTable get instance => _single;
  static final UserTable _single = UserTable._internal();
  UserTable._internal();

  @override
  String get tableName => 'usertable';
  String get columnId      => 'id';
  String get columnName    => 'name';
  String get columnAge     => 'age';
  String get columnEmail   => 'email';
  String get columnAvatar  => 'avatar';
  String get columnBio     => 'bio';
  String get columnGrade   => 'grade';
  String get columnHobbies => 'hobbies';

  @override
  String get build => '''
    CREATE TABLE $tableName (
      $columnId      TEXT PRIMARY KEY,
      $columnName    TEXT NOT NULL,
      $columnAge     INTEGER NOT NULL,
      $columnEmail   TEXT,
      $columnAvatar  TEXT,
      $columnBio     TEXT,
      $columnGrade   TEXT NOT NULL,
      $columnHobbies TEXT NOT NULL
      );
    ''';
}