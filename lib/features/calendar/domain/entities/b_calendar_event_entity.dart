import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';

class ENTCalendarEvent extends ENTCalendar {
  final String? description;

  ENTCalendarEvent({
    required super.id,
    required super.title,
    this.description,
    super.cycle,
    required super.start,
    required super.end,
    super.ignoredDates,
    super.valueColor
  });
}

class ENTCalendarSubject extends ENTCalendar {
  final String subjectId;

  ENTCalendarSubject({
    required super.id,
    required super.title,
    required super.start,
    required super.end,
    super.cycle,
    super.ignoredDates,
    super.valueColor,
    required this.subjectId,
  });
}