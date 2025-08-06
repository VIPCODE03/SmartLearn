import 'package:smart_learn/features/calendar/data/models/zz_cycle_model.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/zz_cycle_entity.dart';

import 'b_calendar_event_model.dart';

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
      "type": type,
      "id": id,
      "title": title,
      "cycle": (cycle as MODCycle?)?.toMap(),
      "start": start.toIso8601String(),
      "end": end.toIso8601String(),
      "valueColor": valueColor,
      "ignoredDates": ignoredDates != null && ignoredDates!.isNotEmpty
          ? ignoredDates!.map((date) => date.toIso8601String()).toList()
          : null,
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
      'id': map['id'] as String,
      'title': map['title'] as String,
      'cycle': map['cycle'] != null ? MODCycle.fromMap(map['cycle']) : null,
      'start': DateTime.parse(map['start'] as String),
      'end': DateTime.parse(map['end'] as String),
      'valueColor': map['valueColor'] as int?,
      'ignoredDates': (map['ignoredDates'] as List<dynamic>?)?.map((dateString) => DateTime.parse(dateString as String)).toList(),
      'childProperties': map['childProperties'] as Map<String, dynamic>?,
    };
  }

  factory MODCalendar.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String;
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