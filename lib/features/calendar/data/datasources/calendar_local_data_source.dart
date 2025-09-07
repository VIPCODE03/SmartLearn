import 'package:smart_learn/core/database/appdatabase.dart';
import 'package:smart_learn/core/database/tables/calendar_table.dart';
import 'package:smart_learn/features/calendar/data/models/a_calendar_model.dart';

CalendarTable get _table => CalendarTable.instance;

abstract class LDSCalendar {
  Future<bool> add(MODCalendar calendar);
  Future<bool> update(MODCalendar calendar);
  Future<bool> delete(String id);

  Future<MODCalendar> getById(String id);
  Future<List<MODCalendar>> getAll();
  Future<List<MODCalendar>> getByDateRange(DateTime start, DateTime end);
  Future<List<MODCalendar>> getEventsOnDate(DateTime startDate);

  Future<List<MODCalendar>> search(String title);
}


class LDSCalendarImpl extends LDSCalendar {
  final _appDatabase = AppDatabase.instance;

  @override
  Future<bool> add(MODCalendar calendar) async {
    final db = await _appDatabase.db;
    final result = await db.insert(
      _table.tableName,
      calendar.toMap(),
    );
    return result > 0;
  }

  @override
  Future<bool> update(MODCalendar calendar) async {
    final db = await _appDatabase.db;
    final result = await db.update(
      _table.tableName,
      calendar.toMap(),
      where: '${_table.columnId} = ?',
      whereArgs: [calendar.id],
    );
    return result > 0;
  }

  @override
  Future<bool> delete(String id) async {
    final db = await _appDatabase.db;
    final result = await db.delete(
      _table.tableName,
      where: '${_table.columnId} = ?',
      whereArgs: [id],
    );
    return result > 0;
  }

  @override
  Future<List<MODCalendar>> getAll() async {
    final db = await _appDatabase.db;
    final result = await db.query(_table.tableName);
    return result.map((e) => MODCalendar.fromMap(e)).toList();
  }

  @override
  Future<List<MODCalendar>> getByDateRange(DateTime start, DateTime end) async {
    final db = await _appDatabase.db;
    final result = await db.query(
      _table.tableName,
      where: '${_table.columnStart} >= ? AND ${_table.columnEnd} <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
    return result.map((e) => MODCalendar.fromMap(e)).toList();
  }

  @override
  Future<MODCalendar> getById(String id) async {
    final db = await _appDatabase.db;
    final result = await db.query(
      _table.tableName,
      where: '${_table.columnId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) throw Exception('Calendar not found');
    return MODCalendar.fromMap(result.first);
  }

  @override
  Future<List<MODCalendar>> search(String title) async {
    final db = await _appDatabase.db;
    final result = await db.query(
      _table.tableName,
      where: '${_table.columnTitle} LIKE ?',
      whereArgs: ['%$title%'],
    );
    return result.map((e) => MODCalendar.fromMap(e)).toList();
  }

  @override
  Future<List<MODCalendar>> getEventsOnDate(DateTime startDate) async {
    throw UnimplementedError();
  }
}