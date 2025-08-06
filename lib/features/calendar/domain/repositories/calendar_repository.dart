
import 'package:dartz/dartz.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';

import '../../../../core/error/failures.dart';

abstract class REPCalendar {
  Future<Either<Failure, void>> add(ENTCalendar calendar);
  Future<Either<Failure, void>> update(ENTCalendar calendar);
  Future<Either<Failure, void>> delete(String id);

  Future<Either<Failure, List<ENTCalendar>>> getById(String id);
  Future<Either<Failure, List<ENTCalendar>>> getAll();
  Future<Either<Failure, List<ENTCalendar>>> getEventsOnDate(DateTime date);
  Future<Either<Failure, List<ENTCalendar>>> getByDateRange(DateTime start, DateTime end);

  Future<Either<Failure, List<ENTCalendar>>> search(String title);
}