
import 'package:smart_learn/features/calendar/data/models/a_calendar_model.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';

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
      'childPropertiesMap': description,
    };
  }

  factory MODCalendarEvent.fromMap(Map<String, dynamic> map) {
    final mapBase = MODCalendar.fromMapBase(map);
    return MODCalendarEvent(
        id: mapBase['id'],
        title: mapBase['title'],
        description: map['childPropertiesMap'] as String?,
        cycle: mapBase['cycle'],
        start: mapBase['start'],
        end: mapBase['end'],
        valueColor: mapBase['valueColor'],
        ignoredDates: mapBase['ignoredDates'],
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
      'subjectId': subjectId,
    };
  }

  factory MODCalendarSucject.fromMap(Map<String, dynamic> map) {
    final mapBase = MODCalendar.fromMapBase(map);
    return MODCalendarSucject(
      id: mapBase['id'],
      title: mapBase['title'],
      subjectId: map['subjectId'] as String,
      cycle: mapBase['cycle'],
      start: mapBase['start'],
      end: mapBase['end'],
      valueColor: mapBase['valueColor'],
      ignoredDates: mapBase['ignoredDates'],
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