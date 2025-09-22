import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/b_calendar_event_entity.dart';
import 'package:smart_learn/features/calendar/domain/entities/zz_cycle_entity.dart';
import 'package:smart_learn/features/calendar/domain/parameters/calendar_params.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

import '../parameters/cycle_params.dart';
import '../repositories/calendar_repository.dart';

class UCECalendarAdd extends UseCase<ENTCalendar, PARCalendarAdd> {
  final REPCalendar _repository;
  UCECalendarAdd(this._repository);

  @override
  Future<Either<Failure, ENTCalendar>> call(PARCalendarAdd params) async {
    ENTCalendar newCalendar;
    ENTCycle? newCycle = switch(params.cycle) {
      PARCycleDaily _ => ENTCycle.daily(),
      PARCycleWeekly days => ENTCycle.weekly(days.daysOfWeek),
      PARCycleNone _ => ENTCycle.none(),
      null => null,
      PARCycle() => throw UnimplementedError(),
    };
    switch(params) {
      case PARCalendarEventAdd _:
        newCalendar = ENTCalendarEvent(
            id: UTIGenerateID.random(),
            title: params.title,
            start: params.start,
            end: params.end,
            cycle: newCycle,
            ignoredDates: params.ignoredDates,
            valueColor: params.valueColor,
            description: params.desc
        );
        break;

      case PARCalendarSubjectAdd _:
        newCalendar = ENTCalendarSubject(
            id: UTIGenerateID.random(),
            title: params.title,
            subjectId: params.subjectId,
            start: params.start,
            end: params.end,
            cycle: newCycle,
            ignoredDates: params.ignoredDates,
            valueColor: params.valueColor
        );
        break;

      default:
        throw UnimplementedError();
    }
    final result = await _repository.add(newCalendar);
    return result.fold(
            (l) => Left(l),
            (sucsess) => sucsess
                ? Right(newCalendar)
                : Left(CacheFailure())
    );
  }
}