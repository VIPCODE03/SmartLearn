import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';

class ENTCalendarEvent extends ENTCalendar {
  final String? description;

  ENTCalendarEvent({
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
  String get type => 'CalendarEvent';
}

class ENTCalendarSubject extends ENTCalendar {
  final String subjectId;

  ENTCalendarSubject({
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
  String get type => "CalendarSubject";
}