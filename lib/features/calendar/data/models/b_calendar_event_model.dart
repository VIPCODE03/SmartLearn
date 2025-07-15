
import 'package:smart_learn/features/calendar/data/models/a_calendar_model.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';

class MODCalendarEvent extends ENTCalendarEvent {
  MODCalendarEvent({
    required super.id,
    required super.title,
    super.description,
    super.cycle,
    required super.startTime,
    required super.endTime,
    required super.startDate,
    super.endDate,
    super.ignoredDates,
    super.valueColor
  });

  Map<String, dynamic> toMap() {
    final map = (this as MODCalendar).toMapBase();
    map['description'] = description;
    return map;
  }

  factory MODCalendarEvent.fromMap(Map<String, dynamic> map) {
    final mapBase = MODCalendar.fromMapBase(map);
    return MODCalendarEvent(
        id: mapBase['id'],
        title: mapBase['title'],
        description: map['description'] as String?,
        cycle: mapBase['cycle'],
        startTime: mapBase['startTime'],
        endTime: mapBase['endTime'],
        startDate: mapBase['startDate'],
        endDate: mapBase['endDate'],
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
      startTime: entity.startTime,
      endTime: entity.endTime,
      startDate: entity.startDate,
      endDate: entity.endDate,
      valueColor: entity.valueColor,
      ignoredDates: entity.ignoredDates,
    );
  }
}

class MODCalendarSucject extends ENTCalendarSubject {
  MODCalendarSucject({
    required super.id,
    required super.title,
    required super.subjectId,
    super.cycle,
    required super.startTime,
    required super.endTime,
    required super.startDate,
    super.endDate,
    super.ignoredDates,
    super.valueColor
  });

  Map<String, dynamic> toMap() {
    final map = (this as MODCalendar).toMapBase();
    map['subjectId'] = subjectId;
    return map;
  }

  factory MODCalendarSucject.fromMap(Map<String, dynamic> map) {
    final mapBase = MODCalendar.fromMapBase(map);
    return MODCalendarSucject(
      id: mapBase['id'],
      title: mapBase['title'],
      subjectId: map['subjectId'] as String,
      cycle: mapBase['cycle'],
      startTime: mapBase['startTime'],
      endTime: mapBase['endTime'],
      startDate: mapBase['startDate'],
      endDate: mapBase['endDate'],
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
      startTime: entity.startTime,
      endTime: entity.endTime,
      startDate: entity.startDate,
      endDate: entity.endDate,
      valueColor: entity.valueColor,
      ignoredDates: entity.ignoredDates,
    );
  }
}