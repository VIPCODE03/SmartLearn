import 'package:smart_learn/features/calendar/domain/entities/zz_cycle_entity.dart';
import 'package:smart_learn/utils/datetime_util.dart';

typedef Time = Map<String, int>;

abstract class ENTCalendar {
  final String id;
  final String title;
  final ENTCycle? cycle;
  final DateTime start;
  final DateTime end;
  final List<DateTime>? ignoredDates;
  final int? valueColor;

  ENTCalendar({
    required this.id,
    required this.title,
    this.cycle,
    required this.start,
    required this.end,
    this.ignoredDates,
    this.valueColor,
  }) : assert(
  end.isAfter(start) &&
      start.hour >= 0 && start.hour < 24 &&
      end.hour >= 0 && end.hour < 24 &&
      start.minute >= 0 && start.minute < 60 &&
      end.minute >= 0 && end.minute < 60,
  'Invalid time: start must be before end, and hour/minute must be in valid range.',
  );

  bool get isInDay => (start.hour * 60 + start.minute) < (end.hour * 60 + end.minute);

  Set<Time> get dates {
    final Set<Time> times = {};
    DateTime current = start;

    if(cycle == null) {
      final totalDate = UTIDateTime.daysBetweenCeil(start, end);
      for(int i = 1; i <= totalDate; i++) {
        if(i == 1) {
          times.add({
            'startTime': start.hour * 60 + start.minute,
            'endTime': (isInDay && totalDate == 1) ? end.hour * 60 + end.minute : 23 * 60 + 59,
            'date': UTIDateTime.dayToInt(current),
          });
        }
        else if(i == totalDate) {
          times.add({
            'startTime': 0,
            'endTime': end.hour * 60 + end.minute,
            'date': UTIDateTime.dayToInt(current),
          });
        }
        else {
          times.add({
            'startTime': 0,
            'endTime': 23 * 60 + 59,
            'date': UTIDateTime.dayToInt(current),
          });
        }
        current = current.add(const Duration(days: 1));
      }
    }

    else {
      final start1 = start.hour * 60 + start.minute;
      final end1 = end.hour * 60 + end.minute;
      const start2 = 0;
      const end2 = 23 * 60 + 59;
      while (!current.isAfter(end)) {
        bool isAdd = false;
        if (cycle!.type == RecurrenceType.daily
            || cycle!.type == RecurrenceType.none
            || cycle!.type == RecurrenceType.weekly &&
                cycle!.daysOfWeek!.contains(current.weekday)
        ) {
          times.add({
            'startTime': start1,
            'endTime': isInDay ? end1 : end2,
            'date': UTIDateTime.dayToInt(current),
          });
          isAdd = true;
        }
        current = current.add(const Duration(days: 1));

        if (isAdd && !isInDay) {
          times.add({
            'startTime': start2,
            'endTime': end1,
            'date': UTIDateTime.dayToInt(current),
          });
        }
      }
    }
    return times;
  }

  List<Map<String, dynamic>> get splitDateTime {
    if(cycle == null) {
      if(isInDay) {
        return [{
          'start': start,
          'end': end,
        }];
      }

      //-Nếu là nhiều ngày  -
      final List<Map<String, dynamic>> result = [];
      //  1. Đầu tiên -
      result.add({
        'start': start,
        'end': DateTime(start.year, start.month, start.day , 23, 59),
        'cycle': null
      });

      // 2. Lặp các ngày giữa (nếu có) → full ngày, dùng cycle hàng ngày  -
      final totalDays = UTIDateTime.daysBetweenCeil(start, end);
      if(totalDays > 1) {
        final midStart = start.add(const Duration(days: 1));
        final midEnd = end.subtract(const Duration(days: 1));
        result.add(
            {
              'start': DateTime(midStart.year, midStart.month, midStart.day, 0, 0),
              'end': DateTime(midEnd.year, midEnd.month, midEnd.day, 23, 59),
              'cycle': ENTCycle.daily()
            }
        );
      }

      // 3. Cuối cùng -
      result.add({
        'start': DateTime(end.year, end.month, end.day, 0, 0),
        'end': end,
        'cycle': null
      });
      return result;
    }
    else {
      if(isInDay) {
        return [{
          'start': start,
          'end': end,
          'cycle': cycle
        }];
      }
      else {
        ENTCycle? newCycle;
        if(cycle!.type == RecurrenceType.weekly) {
          final nextDaysOfWeek = cycle!.daysOfWeek!.map((day) => day % 7 + 1).toSet();
          newCycle = ENTCycle.weekly(nextDaysOfWeek);
        }
        final nextStart = start.add(const Duration(days: 1));
        final prevEnd = end.subtract(const Duration(days: 1));

        return [
          {
            'start': start,
            'end': DateTime(prevEnd.year, prevEnd.month, prevEnd.day , 23, 59),
            'cycle': cycle
          },
          {
            'start': DateTime(nextStart.year, nextStart.month, nextStart.day, 0, 0),
            'end': end,
            'cycle': newCycle ?? cycle
          }
        ];
      }
    }
  }

  //--- Kiểm tra xem sự kiện có diễn ra trong giờ cụ thể  -------------------------
  bool occursInHour(int hour) {
    final startTime = start.hour;
    final endTime = end.hour;
    return (hour >= startTime && hour < endTime) || (hour == endTime && end.minute == 0 && hour != startTime);
  }

  //--- Lấy các phiên bản của 1 ngày cụ thể -------------------------------------
  List<Time> getTimeByDate(DateTime date) {
    final List<Time> times = [];
    for(final time in dates) {
      if(time['date'] == UTIDateTime.dayToInt(date)) {
        times.add(time);
      }
    }
    return times;
  }

  //--- Kiểm tra trùng với 1 lịch khác trong ngày cụ thể  -----------------------
  bool checkDuplicateOnDate(ENTCalendar calendar, DateTime date) {
    final time1 = getTimeByDate(date);
    final time2 = calendar.getTimeByDate(date);
    if(time1.isNotEmpty && time2.isNotEmpty) {
      for(var time in time1) {
        for(var timeOther in time2) {
          if(time['startTime']! <= timeOther['endTime']! && time['endTime']! >= timeOther['startTime']!) {
            return true;
          }
        }
      }
    }
    return false;
  }
}