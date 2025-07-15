
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_learn/features/calendar/data/models/a_calendar_model.dart';

abstract class LDSCalendar {
  static const String _cachedCalendar = 'CACHED_CALENDAR';

  Future<void> add(MODCalendar calendar);
  Future<void> update(MODCalendar calendar);
  Future<void> delete(String id);

  Future<MODCalendar> getById(String id);
  Future<List<MODCalendar>> getAll();
  Future<List<MODCalendar>> getByDate(DateTime date);
  Future<List<MODCalendar>> getByDateRange(DateTime start, DateTime end);

  Future<List<MODCalendar>> search(String title);
}


class LDSCalendarImpl extends LDSCalendar {
  final SharedPreferences sharedPreferences;
  LDSCalendarImpl({required this.sharedPreferences});

  @override
  Future<void> add(MODCalendar calendar) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<MODCalendar>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<List<MODCalendar>> getByDate(DateTime date) {
    // TODO: implement getByDate
    throw UnimplementedError();
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
  Future<void> update(MODCalendar calendar) {
    // TODO: implement update
    throw UnimplementedError();
  }

}