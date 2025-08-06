import 'package:flutter/material.dart';
import 'package:smart_learn/core/feature_widgets/app_widget_provider.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return appWidget.calendar.calendarView();
  }
}


