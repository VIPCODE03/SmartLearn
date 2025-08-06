import 'package:smart_learn/features/calendar/data/models/a_calendar_model.dart';

abstract class LDSCalendar {
  Future<void> add(MODCalendar calendar);
  Future<void> update(MODCalendar calendar);
  Future<void> delete(String id);

  Future<MODCalendar> getById(String id);
  Future<List<MODCalendar>> getAll();
  Future<List<MODCalendar>> getByDateRange(DateTime start, DateTime end);
  Future<List<MODCalendar>> getEventsOnDate(DateTime startDate);

  Future<List<MODCalendar>> search(String title);
}


class LDSCalendarImpl extends LDSCalendar {
  static final List<MODCalendar> demo = [];

  @override
  Future<void> add(MODCalendar calendar) {
    demo.add(calendar);
    return Future.value();
  }

  @override
  Future<void> update(MODCalendar calendar) {
    demo.removeWhere((element) => element.id == calendar.id);
    demo.add(calendar);
    return Future.value();
  }

  @override
  Future<void> delete(String id) {
    demo.removeWhere((element) => element.id == id);
    return Future.value();
  }

  @override
  Future<List<MODCalendar>> getAll() {
    return Future.value(demo);
  }

  @override
  Future<List<MODCalendar>> getByDateRange(DateTime start, DateTime end) {
    // TODO: implement getByDateRange
    throw UnimplementedError();
  }

  @override
  Future<MODCalendar> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<MODCalendar>> search(String title) {
    // TODO: implement search
    throw UnimplementedError();
  }

  @override
  Future<List<MODCalendar>> getEventsOnDate(DateTime startDate) {
    return Future.value(demo);
  }

}