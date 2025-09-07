
import 'package:dartz/dartz.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';

import '../../../../core/error/failures.dart';

abstract class REPCalendar {
  Future<Either<Failure, bool>> add(ENTCalendar calendar);
  Future<Either<Failure, bool>> update(ENTCalendar calendar);
  Future<Either<Failure, bool>> delete(String id);

  Future<Either<Failure, List<ENTCalendar>>> getById(String id);
  Future<Either<Failure, List<ENTCalendar>>> getAll();
  Future<Either<Failure, List<ENTCalendar>>> getEventsOnDate(DateTime date);
  Future<Either<Failure, List<ENTCalendar>>> getByDateRange(DateTime start, DateTime end);

  Future<Either<Failure, List<ENTCalendar>>> search(String title);
}