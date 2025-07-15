
import 'package:smart_learn/features/calendar/data/models/zz_cycle_model.dart';
import 'package:smart_learn/features/calendar/data/models/zz_time_model.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';

import 'b_calendar_event_model.dart';

abstract class MODCalendar extends ENTCalendar {

  MODCalendar({
    required super.id,
    required super.title,
    required super.startTime,
    required super.endTime,
    required super.startDate,
    super.cycle,
    super.endDate,
    super.ignoredDates,
    super.valueColor,
  });

  Map<String, dynamic> toMapBase() {
    return {
      "type": type,
      "id": id,
      "title": title,
      "cycle": (cycle as MODCycle?)?.toMap(),
      "startTime": (startTime as MODTime).toMap(),
      "endTime": (endTime as MODTime).toMap(),
      "startDate": startDate.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "valueColor": valueColor,
      "ignoredDates": ignoredDates != null && ignoredDates!.isNotEmpty
          ? ignoredDates!.map((date) => date.toIso8601String()).toList()
          : null,
    };
  }

  static Map<String, dynamic> fromMapBase(Map<String, dynamic> map) {
    return {
      'id': map['id'] as String,
      'title': map['title'] as String,
      'cycle': map['cycle'] != null ? MODCycle.fromMap(map['cycle']) : null,
      'startTime': MODTime.fromMap(map['startTime']),
      'endTime': MODTime.fromMap(map['endTime']),
      'startDate': DateTime.parse(map['startDate'] as String),
      'endDate': map['endDate'] != null ? DateTime.parse(map['endDate'] as String) : null,
      'valueColor': map['valueColor'] as int?,
      'ignoredDates': (map['ignoredDates'] as List<dynamic>?)?.map((dateString) => DateTime.parse(dateString as String)).toList(),
    };
  }

  factory MODCalendar.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String;
    switch (type) {
      case 'CalendarEvent':
        return MODCalendarEvent.fromMap(map) as MODCalendar;
      case 'CalendarSubject':
        return MODCalendarSucject.fromMap(map) as MODCalendar;
      default:
        throw Exception('Unknown calendar type: $type');
    }
  }

  factory MODCalendar.fromEntity(ENTCalendar entity) {
    final type = entity.type;
    switch (type) {
      case 'CalendarEvent':
        return MODCalendarEvent.fromEntity(entity as ENTCalendarEvent) as MODCalendar;
      case 'CalendarSubject':
        return MODCalendarSucject.fromEntity(entity as ENTCalendarSubject) as MODCalendar;
      default:
        throw Exception('Unknown calendar type: $type');
    }
  }

  Map<String, dynamic> toMap();
}