import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';

import '../repositories/calendar_repository.dart';

class CalendarAddOrUpdateParams extends Equatable {
  final ENTCalendar calendar;
  final bool isUpdate;

  const CalendarAddOrUpdateParams({
    required this.calendar,
    required this.isUpdate,
  });

  @override
  List<Object?> get props => [calendar];
}

class UCECalendarAddOrUpdate extends UseCase<void, CalendarAddOrUpdateParams> {
  final REPCalendar repository;

  UCECalendarAddOrUpdate(this.repository);

  @override
  Future<Either<Failure, void>> call(CalendarAddOrUpdateParams params) {
    if (params.isUpdate) {
      return repository.update(params.calendar);
    } else {
      return repository.add(params.calendar);
    }
  }
}