import 'dart:convert';

import 'package:smart_learn/core/database/tables/calendar_table.dart';
import 'package:smart_learn/features/calendar/data/models/zz_cycle_model.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/zz_cycle_entity.dart';

import 'b_calendar_event_model.dart';

CalendarTable get _table => CalendarTable.instance;

mixin MODCalendarMixin {
  String get id;
  String get title;
  DateTime get start;
  DateTime get end;
  ENTCycle? get cycle;
  List<DateTime>? get ignoredDates;
  int? get valueColor;
  String get type;

  Map<String, dynamic> toMapBase() {
    return {
      _table.columnId: id,
      _table.columnTitle: title,
      _table.columnCycle: cycle != null ? jsonEncode(MODCycle.fromEntity(cycle!).toMap()) : null,
      _table.columnStart: start.toIso8601String(),
      _table.columnEnd: end.toIso8601String(),
      _table.columnValueColor: valueColor,
      _table.columnIgnoredDates: ignoredDates != null && ignoredDates!.isNotEmpty
          ? jsonEncode(ignoredDates!.map((date) => date.toIso8601String()).toList())
          : null,
      _table.columnType: type,
    };
  }
}

abstract class MODCalendar extends ENTCalendar {
  MODCalendar({
    required super.id,
    required super.title,
    required super.start,
    required super.end,
    super.cycle,
    super.ignoredDates,
    super.valueColor,
  });

  Map<String, dynamic> toMap();

  static Map<String, dynamic> fromMapBase(Map<String, dynamic> map) {
    return {
      _table.columnId: map[_table.columnId] as String,
      _table.columnTitle: map[_table.columnTitle] as String,
      _table.columnCycle: map[_table.columnCycle] != null
          ? MODCycle.fromMap(jsonDecode(map[_table.columnCycle]) as Map<String, dynamic>)
          : null,
      _table.columnStart: DateTime.parse(map[_table.columnStart] as String),
      _table.columnEnd: DateTime.parse(map[_table.columnEnd] as String),
      _table.columnValueColor: map[_table.columnValueColor] as int?,
      _table.columnIgnoredDates: map[_table.columnIgnoredDates] != null 
          ? (jsonDecode(map[_table.columnIgnoredDates]) as List<dynamic>).map((e) => DateTime.parse(e as String)).toList()
          : null,
      _table.columnType: map[_table.columnType] as String,
    };
  }

  factory MODCalendar.fromMap(Map<String, dynamic> map) {
    final type = map[_table.columnType] as String;
    switch (type) {
      case 'MODCalendarEvent':
        return MODCalendarEvent.fromMap(map);
      case 'MODCalendarSucject':
        return MODCalendarSucject.fromMap(map);
      default:
        throw Exception('Unknown calendar type: $type');
    }
  }

  factory MODCalendar.fromEntity(ENTCalendar entity) {
    switch (entity) {
      case ENTCalendarEvent _:
        return MODCalendarEvent.fromEntity(entity);
      case ENTCalendarSubject _:
        return MODCalendarSucject.fromEntity(entity);
      default:
        throw Exception('Unknown calendar type: $entity');
    }
  }
}