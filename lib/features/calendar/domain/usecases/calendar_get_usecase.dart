import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/calendar/domain/parameters/calendar_params.dart';

import '../entities/a_calendar_entity.dart';
import '../repositories/calendar_repository.dart';


class UCECalendarGet extends UseCase<List<ENTCalendar>, PARCalendarGet> {
  final REPCalendar _repository;
  UCECalendarGet(this._repository);

  @override
  Future<Either<Failure, List<ENTCalendar>>> call(PARCalendarGet params) {
    switch (params) {
      case PARCalendarGetAll _:
        return _repository.getAll();
      case PARCalendarGetByDate _:
        return _repository.getEventsOnDate(params.date);
      case PARCalendarGetDateRange _:
        return _repository.getByDateRange(params.start, params.end);
      case PARCalendarGetById _:
        return _repository.getById(params.id);
      case PARCalendarSearch _:
        return _repository.search(params.title);
      default:
        throw UnimplementedError();
    }
  }
}