import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/zz_cycle_entity.dart';
import 'package:smart_learn/features/calendar/domain/parameters/calendar_params.dart';

import '../parameters/cycle_params.dart';
import '../repositories/calendar_repository.dart';

class UCECalendarUpdate extends UseCase<ENTCalendar, PARCalendarUpdate> {
  final REPCalendar _repository;
  UCECalendarUpdate(this._repository);

  @override
  Future<Either<Failure, ENTCalendar>> call(PARCalendarUpdate params) async {
    final ENTCalendar calenderUpdated;
    ENTCycle? cycleUpdated = switch(params.cycle) {
      PARCycleDaily _ => ENTCycle.daily(),
      PARCycleWeekly days => ENTCycle.weekly(days.daysOfWeek),
      PARCycleNone _ => ENTCycle.none(),
      null => params.calendar.cycle,
      PARCycle() => throw UnimplementedError(),
    };

    switch(params) {
      case PARCalendarEventUpdate _:
        calenderUpdated = ENTCalendarEvent(
          id: params.calendar.id,
          title: params.title ?? params.calendar.title,
          start: params.start ?? params.calendar.start,
          end: params.end ?? params.calendar.end,
          cycle: cycleUpdated,
          ignoredDates: params.ignoredDates ?? params.calendar.ignoredDates,
          valueColor: params.valueColor ?? params.calendar.valueColor,
          description: params.desc ?? params.calendar.description,
        );
        break;

      case PARCalendarSubjectUpdate _:
        calenderUpdated = ENTCalendarSubject(
          id: params.calendar.id,
          title: params.title ?? params.calendar.title,
          subjectId: params.subjectId ?? params.calendar.subjectId,
          start: params.start ?? params.calendar.start,
          end: params.end ?? params.calendar.end,
          cycle: cycleUpdated,
          ignoredDates: params.ignoredDates ?? params.calendar.ignoredDates,
          valueColor: params.valueColor ?? params.calendar.valueColor,
        );
        break;

      default:
        throw UnimplementedError();
    }

    final result = await _repository.update(calenderUpdated);
    return result.fold(
            (l) => Left(l),
            (sucsess) => sucsess
                ? Right(calenderUpdated)
                : Left(CacheFailure())
    );
  }
}