
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';

import '../entities/a_calendar_entity.dart';
import '../repositories/calendar_repository.dart';

enum CalendarTypeGet {
  all,
  byDate,
  byDateRange,
  byId,
  search,
}

class CalendarGetParams extends Equatable {
  final CalendarTypeGet type;
  final String? title;
  final String? id;
  final DateTime? date;
  final DateTime? start;
  final DateTime? end;

  const CalendarGetParams({
    required this.type,
    this.title,
    this.id,
    this.date,
    this.start,
    this.end,
  });

  @override
  List<Object?> get props => [type];
}

class UCECalendarGet extends UseCase<List<ENTCalendar>, CalendarGetParams> {
  final REPCalendar repository;
  UCECalendarGet(this.repository);

  @override
  Future<Either<Failure, List<ENTCalendar>>> call(CalendarGetParams params) {
    switch (params.type) {
      case CalendarTypeGet.all:
        return repository.getAll();
      case CalendarTypeGet.byDate:
        return repository.getByDate(params.date!);
      case CalendarTypeGet.byDateRange:
        return repository.getByDateRange(params.start!, params.end!);
      case CalendarTypeGet.byId:
        return repository.getById(params.id!);
      case CalendarTypeGet.search:
        return repository.search(params.title!);
    }
  }
}