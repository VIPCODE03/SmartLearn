
import 'package:flutter/cupertino.dart';
import 'package:smart_learn/features/calendar/domain/entities/a_calendar_entity.dart';
import 'package:smart_learn/features/calendar/domain/usecases/calendar_get_usecase.dart';

class VMLDaily extends ChangeNotifier {
  DateTime _current;
  final UCECalendarGet _getCalendar;
  VMLDaily({
    required DateTime current,
    required UCECalendarGet getCalendar,
  }) : _getCalendar = getCalendar,
        _current = current {
    _loadEvents();
  }

  set current(DateTime value) {
    _current = value;
    _loadEvents();
  }

  DateTime get current => _current;

  //-- Danh sách sự kiện  -----------------------------------------------------------------------------------
  List<ENTCalendar> _events = [];
  List<ENTCalendar> get events => _events;
  set events(List<ENTCalendar> value) {
    _events = value;
    notifyListeners();
  }

  Future<void> _loadEvents() async {
    final result = await _getCalendar(CalendarGetParams.byDate(_current));
    result.fold(
            (fail) {
              debugPrint(fail.toString());
              events = [];
            },
            (datas) {
              events = datas;
            }
    );
  }
}