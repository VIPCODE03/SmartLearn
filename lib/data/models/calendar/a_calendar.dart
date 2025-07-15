import 'dart:convert';
import 'package:smart_learn/data/models/calendar/b_calendar_event.dart';
import 'package:smart_learn/data/models/calendar/zz_cycle.dart';
import 'package:smart_learn/data/models/calendar/zz_time.dart';

abstract class Calendar {
  final String id;
  final String title;
  final Cycle? cycle;
  final Time startTime;
  final Time endTime;
  final DateTime startDate;
  final DateTime? endDate;
  final List<DateTime>? ignoredDates;
  final int? valueColor;

  String get type;

  Calendar({
    required this.id,
    required this.title,
    this.cycle,
    required this.startTime,
    required this.endTime,
    required this.startDate,
    this.endDate,
    this.ignoredDates,
    this.valueColor
  })
      : assert(endDate == null || !endDate.isBefore(startDate),
  'recurringEnd cannot be before recurringStart');

  Map<String, dynamic> toMapBase() {
    return {
      "type": type,
      "id": id,
      "title": title,
      "cycle": cycle != null ? jsonEncode(cycle!.toMap()) : null,
      "startTime": jsonEncode(startTime.toMap()),
      "endTime": jsonEncode(endTime.toMap()),
      "startDate": startDate.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "valueColor": valueColor,
      "ignoredDates": ignoredDates != null && ignoredDates!.isNotEmpty
          ? jsonEncode(ignoredDates!.map((date) => date.toIso8601String()).toList())
          : null,
    };
  }

  static Map<String, dynamic> parseFromMapBase(Map<String, dynamic> map) {
    return {
      'id': map['id'] as String,
      'title': map['title'] as String,
      'cycle': map['cycle'] != null
          ? Cycle.fromMap(jsonDecode(map['cycle']))
          : null,
      'startTime': Time.fromMap(jsonDecode(map['startTime'])),
      'endTime': Time.fromMap(jsonDecode(map['endTime'])),
      'startDate': DateTime.parse(map['startDate'] as String),
      'endDate': map['endDate'] != null
          ? DateTime.parse(map['endDate'] as String)
          : null,
      'valueColor': map['valueColor'] as int?,
      'ignoredDates': (map['ignoredDates'] != null)
          ? (jsonDecode(map['ignoredDates'] as String) as List<dynamic>)
          .map((dateString) => DateTime.parse(dateString as String))
          .toList()
          : null,
    };
  }

  Map<String, dynamic> toMap();

  factory Calendar.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String?;
    switch(type) {
      case 'CalendarEvent':
        return CalendarEvent.fromMap(map);
      case 'CalendarSubject':
        return CalendarSubject.fromMap(map);
      default:
        throw ArgumentError('Unknown Calendar type: $type');
    }
  }

  //--- Kiểm tra xem sự kiện có diễn ra trong giờ cụ thể  -------------------------
  bool occursInHour(int hour) {
    final start = startTime.hour;
    final end = endTime.hour;
    return (hour >= start && hour < end) || (hour == end && endTime.minute == 0 && hour != start);
  }

  //--- Kiểm tra trùng trong khoảng giờ cụ thể  ----------------------------------
  bool intersects(Time checkStartTime, Time checkEndTime) {
    return startTime.isBefore(checkEndTime) && endTime.isAfter(checkStartTime);
  }

  //--- Kiểm tra sự kiện diễn ra trong ngày cụ thể  -------------------------------
  bool occursOnDate(DateTime targetDate) {

    final DateTime normalizedTargetDate = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final DateTime normalizedStartDate = DateTime(startDate.year, startDate.month, startDate.day);
    final DateTime? normalizedEndDate = endDate != null ? DateTime(endDate!.year, endDate!.month, endDate!.day) : null;

    //--- BỎ QUA  ---
    if (ignoredDates != null
        && ignoredDates!
            .any((ignoredDate) => DateTime(ignoredDate.year, ignoredDate.month, ignoredDate.day)
            .isAtSameMomentAs(normalizedTargetDate)
    )) {
      return false;
    }

    //--- KHÔNG CHU KỲ  ---
    // Mặc định startDate = endDate
    if (cycle == null) {
      return normalizedTargetDate.isAtSameMomentAs(normalizedStartDate);
    }

    //--- CÓ CHU KỲ ---
    else {
      bool isInDateRange = (normalizedTargetDate.isAtSameMomentAs(normalizedStartDate) || normalizedTargetDate.isAfter(normalizedStartDate)) &&
          (normalizedEndDate == null || normalizedTargetDate.isAtSameMomentAs(normalizedEndDate) || normalizedTargetDate.isBefore(normalizedEndDate));

      //->  Không nằm trong phạm vi
      if (!isInDateRange) {
        return false;
      }

      //-> Nằm trong phạm vi
      //- Kiểm tra chu kỳ
      switch (cycle!.type) {
        case RecurrenceType.daily:
          return true;
        case RecurrenceType.weekly:
          final DayOfWeek currentDayOfWeek = DayOfWeek.values[normalizedTargetDate.weekday - 1];
          return cycle!.daysOfWeek != null && cycle!.daysOfWeek!.contains(currentDayOfWeek);
        case RecurrenceType.none:
          return normalizedTargetDate.isAtSameMomentAs(normalizedStartDate);
      }
    }
  }
}