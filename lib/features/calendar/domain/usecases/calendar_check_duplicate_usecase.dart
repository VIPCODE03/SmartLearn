
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/zz_cycle_entity.dart';
import 'package:smart_learn/features/calendar/domain/repositories/calendar_repository.dart';

import '../../../../utils/datetime_util.dart';

class CalendarCheckDuplicateParams extends Equatable {
  final ENTCalendar calendar;
  const CalendarCheckDuplicateParams({required this.calendar});

  @override
  List<Object?> get props => [calendar];
}

class UCECalendarCheckDuplicate extends UseCase<bool, CalendarCheckDuplicateParams> {
  final REPCalendar repository;
  UCECalendarCheckDuplicate(this.repository);

  @override
  Future<Either<Failure, bool>> call(CalendarCheckDuplicateParams params) async {
    try {
      final all = await repository.getAll();
      if(all.isRight()) {
        final List<ENTCalendar> allValue = all.getOrElse(() => []);
        for (ENTCalendar calendar in allValue) {
          if (calendar.id == params.calendar.id) {
            continue;
          }
          if (_checkDuplicate(params.calendar, calendar)) {
            return const Right(true);
          }
        }
      }
      else {
        return Left(all.fold((l) => l, (r) => CacheFailure()));
      }
      return const Right(false);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  //--- Kiểm tra trùng lịch -----------------------------------------------------
  bool _checkDuplicate(ENTCalendar calendar1, ENTCalendar calendar2) {
    //- 1.Kiểm tra thời gian start->end  ---
    if(calendar1.end.isBefore(calendar2.start) || calendar1.start.isAfter(calendar2.end)) {
      return false;
    }

    //- 2, Kiểm tra các phiên bản -
    bool isDuplicate = false;
    final maps1 = calendar1.splitDateTime;
    final maps2 = calendar2.splitDateTime;

    for(final map1 in maps1) {
      final start1 = map1['start'] as DateTime;
      final end1 = map1['end'] as DateTime;
      final cycle1 = map1['cycle'] as ENTCycle?;
      for(final map2 in maps2) {
        final start2 = map2['start'] as DateTime;
        final end2 = map2['end'] as DateTime;
        final cycle2 = map2['cycle'] as ENTCycle?;

        isDuplicate = _checkPathDuplicate(
          start1: start1,
          end1: end1,
          cycle1: cycle1,
          start2: start2,
          end2: end2,
          cycle2: cycle2,
        );

        if(isDuplicate) {
          break;
        }
      }
      if(isDuplicate) {
        break;
      }
    }
    return isDuplicate;
  }

  bool _checkPathDuplicate({
    required DateTime start1,
    required DateTime end1,
    required ENTCycle? cycle1,
    required DateTime start2,
    required DateTime end2,
    required ENTCycle? cycle2,
  }) {
    if (!_checkTimeDuplicate(start1: start1, end1: end1, start2: start2, end2: end2)) {
      return false;
    }
    if (_checkDateDuplicate(start1: start1, end1: end1, cycle1: cycle1, start2: start2, end2: end2, cycle2: cycle2)) {
      return true;
    }
    return false;
  }

  //- Kiểm tra trùng thời gian  ------------------------------------------------
  bool _checkTimeDuplicate({required DateTime start1, required DateTime end1, required DateTime start2, required DateTime end2}) {
    final startTime1 = start1.hour * 60 + start1.minute;
    final endTime1 = end1.hour * 60 + end1.minute;
    final startTime2 = start2.hour * 60 + start2.minute;
    final endTime2 = end2.hour * 60 + end2.minute;

    final isDuplicate = (startTime1 < endTime2 && endTime1 > startTime2);

    return isDuplicate;
  }

  //- Kiểm tra trùng ngày ------------------------------------------------------
  bool _checkDateDuplicate({
    required DateTime start1,
    required DateTime end1,
    required ENTCycle? cycle1,
    required DateTime start2,
    required DateTime end2,
    required ENTCycle? cycle2,
  }) {
    final Set<int> dates1 = _getRecurringDateStrings(start: start1, end: end1, cycle: cycle1).toSet();
    final Set<int> dates2 = _getRecurringDateStrings(start: start2, end: end2, cycle: cycle2).toSet();

    final isDuplicate = dates1.intersection(dates2).isNotEmpty;

    return isDuplicate;
  }

  //- Lấy các ngày  ------------------------------------------------------------
  List<int> _getRecurringDateStrings({
    required DateTime start,
    required DateTime end,
    required ENTCycle? cycle
  }) {
    final List<int> recurringDates = [];
    DateTime currentDate = start;

    while (!currentDate.isAfter(end)) {
      if (cycle == null || cycle.type == RecurrenceType.daily || cycle.type == RecurrenceType.none) {
        recurringDates.add(UTIDateTime.dayToInt(currentDate));
      } else if (cycle.type == RecurrenceType.weekly && cycle.daysOfWeek!.contains(currentDate.weekday)) {
        recurringDates.add(UTIDateTime.dayToInt(currentDate));
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return recurringDates;
  }
}