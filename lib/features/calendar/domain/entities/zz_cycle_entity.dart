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

class ENTCycle {
  final RecurrenceType type;
  final List<DayOfWeek>? daysOfWeek;

  ENTCycle({
    required this.type,
    this.daysOfWeek,
  }) : assert(
  (type == RecurrenceType.weekly && daysOfWeek != null && daysOfWeek.isNotEmpty) ||
      (type != RecurrenceType.weekly && daysOfWeek == null),
  'Invalid Cycle configuration for type $type'
  );

  bool get requiresDaysOfWeek => type == RecurrenceType.weekly;
}