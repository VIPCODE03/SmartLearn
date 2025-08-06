import 'package:flutter/cupertino.dart';
import 'package:smart_learn/core/router/app_router_mixin.dart';
import 'package:smart_learn/features/calendar/presentation/screens/calendar_screen.dart';

abstract class ICalendarWidget {
  Widget calendarView();
}

abstract class ICalendarRouter {
  void goCalendarScreen(BuildContext context);
}

class _CalendarWidget implements ICalendarWidget {
  static final _CalendarWidget _singleton = _CalendarWidget._internal();
  _CalendarWidget._internal();
  static _CalendarWidget get instance => _singleton;

  @override
  Widget calendarView() => const SCRCalendar();
}

class _CalendarRouter extends ICalendarRouter with AppRouterMixin {
  static final _CalendarRouter _singleton = _CalendarRouter._internal();
  _CalendarRouter._internal();
  static _CalendarRouter get instance => _singleton;

  @override
  void goCalendarScreen(BuildContext context) {
    pushSlideLeft(context, const SCRCalendar());
  }
}

class CalendarProvider {
  static final CalendarProvider _singleton = CalendarProvider._internal();
  CalendarProvider._internal();
  static CalendarProvider get instance => _singleton;

  ICalendarWidget get widget => _CalendarWidget.instance;
  ICalendarRouter get router => _CalendarRouter.instance;
}
