import 'package:smart_learn/core/database/tables/calendar_table.dart';
import 'package:smart_learn/features/calendar/data/models/a_calendar_model.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';

CalendarTable get _table => CalendarTable.instance;

class MODCalendarEvent extends ENTCalendarEvent with MODCalendarMixin implements MODCalendar {
  MODCalendarEvent({
    required super.id,
    required super.title,
    super.description,
    super.cycle,
    required super.start,
    required super.end,
    super.ignoredDates,
    super.valueColor
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...toMapBase(),
      _table.columnChildProperties: description,
    };
  }

  factory MODCalendarEvent.fromMap(Map<String, dynamic> map) {
    final mapBase = MODCalendar.fromMapBase(map);
    return MODCalendarEvent(
        id: mapBase[_table.columnId],
        title: mapBase[_table.columnTitle],
        description: map[_table.columnChildProperties] as String?,
        cycle: mapBase[_table.columnCycle],
        start: mapBase[_table.columnStart],
        end: mapBase[_table.columnEnd],
        valueColor: mapBase[_table.columnValueColor],
        ignoredDates: mapBase[_table.columnIgnoredDates],
      );
  }

  factory MODCalendarEvent.fromEntity(ENTCalendarEvent entity) {
    return MODCalendarEvent(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      cycle: entity.cycle,
      start: entity.start,
      end: entity.end,
      valueColor: entity.valueColor,
      ignoredDates: entity.ignoredDates,
    );
  }

  @override
  String get type => 'MODCalendarEvent';
}

class MODCalendarSucject extends ENTCalendarSubject with MODCalendarMixin implements MODCalendar {
  MODCalendarSucject({
    required super.id,
    required super.title,
    required super.subjectId,
    super.cycle,
    required super.start,
    required super.end,
    super.ignoredDates,
    super.valueColor
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...toMapBase(),
      _table.columnChildProperties: subjectId,
    };
  }

  factory MODCalendarSucject.fromMap(Map<String, dynamic> map) {
    final mapBase = MODCalendar.fromMapBase(map);
    return MODCalendarSucject(
      id: mapBase[_table.columnId],
      title: mapBase[_table.columnTitle],
      subjectId: map[_table.columnChildProperties] as String,
      cycle: mapBase[_table.columnCycle],
      start: mapBase[_table.columnStart],
      end: mapBase[_table.columnEnd],
      valueColor: mapBase[_table.columnValueColor],
      ignoredDates: mapBase[_table.columnIgnoredDates],
    );
  }

  factory MODCalendarSucject.fromEntity(ENTCalendarSubject entity) {
    return MODCalendarSucject(
      id: entity.id,
      title: entity.title,
      subjectId: entity.subjectId,
      cycle: entity.cycle,
      start: entity.start,
      end: entity.end,
      valueColor: entity.valueColor,
      ignoredDates: entity.ignoredDates,
    );
  }

  @override
  String get type => 'MODCalendarSucject';
}