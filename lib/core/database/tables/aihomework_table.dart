
import 'package:smart_learn/core/database/tables/table.dart';

class AIHomeWorkTable extends Table {
  static AIHomeWorkTable get instance => AIHomeWorkTable();
  @override
  String get tableName => 'aihomework';
  String get columnId => 'id';
  String get columnTextQuestion => 'textQuestion';
  String get columnImagePath => 'image';
  String get columnTextAnswer => 'textAnswer';
  String get columnCreatedAt => 'createdAt';

  @override
  String get build => '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnTextQuestion TEXT NOT NULL,
      $columnImagePath TEXT,
      $columnTextAnswer TEXT NOT NULL,
      $columnCreatedAt TEXT NOT NULL
      );
  ''';
}
