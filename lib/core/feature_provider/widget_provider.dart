
import 'package:flutter/cupertino.dart';

import '../../features/focus/presentation/widgets/export/export_manage_focus.dart';

final appWidget = AppWidget.instance;

class AppWidget {
  static final AppWidget _singleton = AppWidget._internal();
  AppWidget._internal();

  static AppWidget get instance => _singleton;

  final focusWidget = _FocusWidget.instance;
  final calendarWidget = _CalendarWidget.instance;
}

class _FocusWidget {
  static final _FocusWidget _singleton = _FocusWidget._internal();
  _FocusWidget._internal();
  static _FocusWidget get instance => _singleton;

  Widget focusManage(FocusBuilder builder) => WIDFocusStatus(buildWidget: builder);
}

class _CalendarWidget {
  static final _CalendarWidget _singleton = _CalendarWidget._internal();
  _CalendarWidget._internal();
  static _CalendarWidget get instance => _singleton;
}
