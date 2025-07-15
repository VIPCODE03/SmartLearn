
import 'package:smart_learn/data/models/calendar/a_calendar.dart';

class CalendarEvent extends Calendar {
  final String? description;

  CalendarEvent({
    required super.id,
    required super.title,
    this.description,
    super.cycle,
    required super.startTime,
    required super.endTime,
    required super.startDate,
    super.endDate,
    super.ignoredDates,
    super.valueColor
  });

  @override
  Map<String, dynamic> toMap() {
    final map = toMapBase();
    map['description'] = description;
    return map;
  }

  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    final mapBase = Calendar.parseFromMapBase(map);
    return CalendarEvent(
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

  @override
  String get type => 'CalendarEvent';
}

class CalendarSubject extends Calendar {
  final String subjectId;

  CalendarSubject({
    required super.id,
    required super.title,
    required super.startTime,
    required super.endTime,
    required super.startDate,
    super.endDate,
    super.cycle,
    super.ignoredDates,
    super.valueColor,
    required this.subjectId,
  });

  @override
  Map<String, dynamic> toMap() {
    final map = toMapBase();
    map['subjectId'] = subjectId;
    return map;
  }

  factory CalendarSubject.fromMap(Map<String, dynamic> map) {
    final mapBase = Calendar.parseFromMapBase(map);
    return CalendarSubject(
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

  @override
  String get type => "CalendarSubject";
}