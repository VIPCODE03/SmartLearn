
import 'package:smart_learn/features/focus/domain/entities/weekly_focus_entity.dart';

class MODWeeklyFocus extends ENTWeeklyFocus {
  MODWeeklyFocus({required super.year, required super.weekNumber, required super.durations});

  MODWeeklyFocus.empty() : super(year: 0, weekNumber: 0, durations: {});

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'week': weekNumber,
      'durations': durations.map((key, value) => MapEntry(key.name, value.inSeconds)),
    };
  }

  factory MODWeeklyFocus.fromJson(Map<String, dynamic> json) {
    return MODWeeklyFocus(
      year: json['year'],
      weekNumber: json['week'],
      durations: Map.fromEntries(
        (json['durations'] as Map<String, dynamic>).entries.map((e) => MapEntry(
          WeekDay.values.firstWhere((w) => w.name == e.key),
          Duration(seconds: e.value),
        )),
      ),
    );
  }

  factory MODWeeklyFocus.fromEntity(ENTWeeklyFocus entity) {
    return MODWeeklyFocus(
      year: entity.year,
      weekNumber: entity.weekNumber,
      durations: entity.durations,
    );
  }
}