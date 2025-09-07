import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';
import 'package:smart_learn/features/calendar/domain/parameters/cycle_params.dart';

abstract class PARCalendar {}

abstract class PARCalendarAdd extends PARCalendar {
  final String title;
  final DateTime start;
  final DateTime end;
  final PARCycle? cycle;
  final List<DateTime>? ignoredDates;
  final int? valueColor;

  PARCalendarAdd({
    required this.title,
    required this.start,
    required this.end,
    this.cycle,
    this.ignoredDates,
    this.valueColor
  });
}

class PARCalendarEventAdd extends PARCalendarAdd {
  final String desc;
  PARCalendarEventAdd({
    required super.title,
    required super.start,
    required super.end,
    super.cycle,
    super.ignoredDates,
    super.valueColor,
    required this.desc,
  });
}

class PARCalendarSubjectAdd extends PARCalendarAdd {
  final String subjectId;
  PARCalendarSubjectAdd({
    required super.title,
    required super.start,
    required super.end,
    super.cycle,
    super.ignoredDates,
    super.valueColor,
    required this.subjectId,
  });
}


abstract class PARCalendarUpdate<T extends ENTCalendar> extends PARCalendar {
  final T calendar;
  final String? title;
  final DateTime? start;
  final DateTime? end;
  final PARCycle? cycle;
  final List<DateTime>? ignoredDates;
  final int? valueColor;

  PARCalendarUpdate(
    this.calendar, {
      this.title,
      this.start,
      this.end,
      this.cycle,
      this.ignoredDates,
      this.valueColor,
  });
}

class PARCalendarEventUpdate extends PARCalendarUpdate<ENTCalendarEvent> {
  final String? desc;
  PARCalendarEventUpdate(
    super.calendar, {
      super.title,
      super.start,
      super.end,
      super.cycle,
      super.ignoredDates,
      super.valueColor,
      this.desc,
  });
}

class PARCalendarSubjectUpdate extends PARCalendarUpdate<ENTCalendarSubject> {
  final String? subjectId;
  PARCalendarSubjectUpdate(
    super.calendar, {
      super.title,
      super.start,
      super.end,
      super.cycle,
      super.ignoredDates,
      super.valueColor,
      this.subjectId,
  });
}


class PARCalendarDelete extends PARCalendar {
  final String id;
  PARCalendarDelete(this.id);
}


class PARCalendarCheckDuplicate extends PARCalendar {
  final String? id;
  final DateTime start;
  final DateTime end;
  final PARCycle? cycle;
  PARCalendarCheckDuplicate({
    this.id,
    required this.start,
    required this.end,
    required this.cycle
  });
}


abstract class PARCalendarGet extends PARCalendar {}

class PARCalendarGetAll extends PARCalendarGet {}

class PARCalendarGetById extends PARCalendarGet {
  final String id;
  PARCalendarGetById(this.id);
}

class PARCalendarGetByDate extends PARCalendarGet {
  final DateTime date;
  PARCalendarGetByDate(this.date);
}

class PARCalendarGetDateRange extends PARCalendarGet {
  final DateTime start;
  final DateTime end;
  PARCalendarGetDateRange(this.start, this.end);
}

class PARCalendarSearch extends PARCalendarGet {
  final String title;
  PARCalendarSearch(this.title);
}