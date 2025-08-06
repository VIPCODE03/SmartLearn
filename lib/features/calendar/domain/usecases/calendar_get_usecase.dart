
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

  const CalendarGetParams.all()
      : this(type: CalendarTypeGet.all);

  const CalendarGetParams.byDate(DateTime date)
      : this(type: CalendarTypeGet.byDate, date: date);

  const CalendarGetParams.byDateRange(DateTime start, DateTime end)
      : this(type: CalendarTypeGet.byDateRange, start: start, end: end);

  const CalendarGetParams.byId(String id)
      : this(type: CalendarTypeGet.byId, id: id);

  const CalendarGetParams.search(String title)
      : this(type: CalendarTypeGet.search, title: title);

  @override
  List<Object?> get props => [type, title, id, date, start, end];
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
        assert(params.date != null, 'Date must not be null for byDate');
        return repository.getEventsOnDate(params.date!);
      case CalendarTypeGet.byDateRange:
        assert(params.start != null && params.end != null, 'Start and End must not be null for byDateRange');
        return repository.getByDateRange(params.start!, params.end!);
      case CalendarTypeGet.byId:
        assert(params.id != null, 'ID must not be null for byId');
        return repository.getById(params.id!);
      case CalendarTypeGet.search:
        assert(params.title != null, 'Title must not be null for search');
        return repository.search(params.title!);
    }
  }

  // Future<Either<Failure, List<ENTCalendar>>> _byDate(DateTime date) async {
  //   final result = await repository.getEventsOnDate(date);
  //   result.fold(
  //           (fail) {
  //             return Left(fail);
  //           },
  //           (datas) {
  //             final List<ENTCalendar> eventsInDate = [];
  //             final int dateCurrent = UTIDateTime.dayToInt(date);
  //             for(final data in datas) {
  //               for (var date in data.dates) {
  //                 if(date['date'] == dateCurrent) {}
  //               }
  //             }
  //           }
  //   );
  // }
}