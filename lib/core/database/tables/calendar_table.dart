import 'package:smart_learn/core/database/tables/table.dart';

class CalendarTable extends Table {
  static CalendarTable get instance => _instance;
  static final CalendarTable _instance = CalendarTable._();
  CalendarTable._();

  @override
  String get tableName => 'calendar';

  String get columnId             => 'id';
  String get columnTitle          => 'title';
  String get columnStart          => 'start';
  String get columnEnd            => 'end';
  String get columnCycle          => 'cycle';
  String get columnValueColor     => 'valueColor';
  String get columnIgnoredDates   => 'ignoredDates';
  String get columnType           => 'type';

  String get columnChildProperties=> 'childproperties';

  @override
  String get build => '''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnTitle TEXT NOT NULL,
      $columnStart TEXT NOT NULL,
      $columnEnd TEXT NOT NULL,
      $columnCycle TEXT,
      $columnValueColor INTEGER,
      $columnIgnoredDates TEXT,
      $columnType TEXT NOT NULL,
      
      $columnChildProperties TEXT
    );
  ''';
}
