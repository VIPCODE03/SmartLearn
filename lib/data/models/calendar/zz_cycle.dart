enum RecurrenceType {
  daily,
  weekly,
  none,
}

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class Cycle {
  final RecurrenceType type;
  final List<DayOfWeek>? daysOfWeek;

  Cycle({
    required this.type,
    this.daysOfWeek,
  }) : assert(
  (type == RecurrenceType.weekly && daysOfWeek != null && daysOfWeek.isNotEmpty) ||
      (type != RecurrenceType.weekly && daysOfWeek == null),
  'Invalid Cycle configuration for type $type'
  );

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'daysOfWeek': daysOfWeek?.map((day) => day.name).toList(),
    };
  }

  factory Cycle.fromMap(Map<String, dynamic> map) {
    return Cycle(
      type: RecurrenceType.values.firstWhere((e) => e.name == map['type']),
      daysOfWeek: (map['daysOfWeek'] as List<dynamic>?)
          ?.map((dayName) => DayOfWeek.values.firstWhere((e) => e.name == dayName))
          .toList(),
    );
  }

  bool get requiresDaysOfWeek => type == RecurrenceType.weekly;
}