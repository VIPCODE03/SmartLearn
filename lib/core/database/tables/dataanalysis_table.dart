import 'package:smart_learn/core/database/tables/table.dart';

class DataAnalysisTable extends Table {
  static DataAnalysisTable get instance => _instance;
  static final DataAnalysisTable _instance = DataAnalysisTable._extenal();
  DataAnalysisTable._extenal();

  @override
  String get tableName => 'personalization';
  String get columnId => 'id';
  String get columnTag => 'tag';
  String get columnOwnerId => 'ownerId';
  String get columnAnalysis => 'personalization';
  String get columnVersion => 'version';

  @override
  String get build => '''
  CREATE TABLE $tableName (
    $columnId TEXT PRIMARY KEY,
    $columnTag TEXT NOT NULL,
    $columnOwnerId TEXT NOT NULL UNIQUE,
    $columnAnalysis TEXT NOT NULL,
    $columnVersion INTEGER NOT NULL
  );
  ''';
}
