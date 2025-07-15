import 'package:smart_learn/features/calendar/domain/entities/zz_cycle_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/zz_time_entity.dart';

abstract class ENTCalendar {
  final String id;
  final String title;
  final ENTCycle? cycle;
  final ENTTime startTime;
  final ENTTime endTime;
  final DateTime startDate;
  final DateTime? endDate;
  final List<DateTime>? ignoredDates;
  final int? valueColor;

  String get type;

  ENTCalendar({
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

  //--- Kiểm tra xem sự kiện có diễn ra trong giờ cụ thể  -------------------------
  bool occursInHour(int hour) {
    final start = startTime.hour;
    final end = endTime.hour;
    return (hour >= start && hour < end) || (hour == end && endTime.minute == 0 && hour != start);
  }

  //--- Kiểm tra trùng trong khoảng giờ cụ thể  ----------------------------------
  bool intersects(ENTTime checkStartTime, ENTTime checkEndTime) {
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