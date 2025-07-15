import 'dart:async';
import 'package:performer/main.dart';

import '../../../domain/entities/weekly_focus_entity.dart';

abstract class FocusState extends DataState {
  final Duration elapsed;
  final ENTWeeklyFocus weeklyFocus;

  const FocusState({
    required this.elapsed,
    required this.weeklyFocus,
  });
}

class FocusInitState extends FocusState {
  FocusInitState() : super(
      elapsed: Duration.zero,
      weeklyFocus: ENTWeeklyFocus(year: 0, weekNumber: 0, durations: const {})
  );

  @override
  List<Object?> get props => [elapsed, weeklyFocus];
}

class FocusInitiated extends FocusState {
  const FocusInitiated({required super.elapsed, required super.weeklyFocus});

  @override
  List<Object?> get props => [elapsed, weeklyFocus];
}

class FocusInitError extends FocusState {
  const FocusInitError({required super.elapsed, required super.weeklyFocus});
  @override
  List<Object?> get props => [elapsed, weeklyFocus];
}

class FocusingState extends FocusState {
  const FocusingState({required super.elapsed, required super.weeklyFocus});

  @override
  List<Object?> get props => [elapsed, weeklyFocus];
}
