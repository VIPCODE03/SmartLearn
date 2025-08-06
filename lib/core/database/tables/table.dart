abstract class Table {
  String get tableName;
  String get build;
}

abstract class TableLink extends Table {
  String get columnLinkId => 'linkid';
  String get columnTag => 'linktag';

  @override
  String get build => '''
      CREATE TABLE $tableName (
      $columnLinkId   TEXT PRIMARY KEY,
      $columnTag      TEXT NOT NULL
      );
  ''';
}