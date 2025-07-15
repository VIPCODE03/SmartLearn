import 'dart:collection';

import 'package:equatable/equatable.dart';

enum WeekDay { mon, tue, wed, thu, fri, sat, sun }

extension WeekDayExt on WeekDay {
  String get name => ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'][index];
}

class ENTWeeklyFocus extends Equatable {
  final int year;
  final int weekNumber;
  final UnmodifiableMapView<WeekDay, Duration> durations;

  ENTWeeklyFocus({
    required this.year,
    required this.weekNumber,
    required Map<WeekDay, Duration> durations,
  }) : durations = UnmodifiableMapView(durations);

  Duration get total =>
      durations.values.fold(Duration.zero, (sum, d) => sum + d);

  List<double> get hourList => List.generate(7, (index) {
    final day = WeekDay.values[index];
    final duration = durations[day] ?? Duration.zero;
    return duration.inMinutes / 60.0;
  });

  @override
  List<Object?> get props => [year, weekNumber, durations];
}
