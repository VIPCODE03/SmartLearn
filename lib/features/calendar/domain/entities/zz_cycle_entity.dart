enum RecurrenceType {
  daily,
  weekly,
  none,
}

class ENTCycle {
  final RecurrenceType type;
  final Set<int>? daysOfWeek;

  ENTCycle({
    required this.type,
    this.daysOfWeek,
  }) : assert(
  (type == RecurrenceType.weekly && daysOfWeek != null && daysOfWeek.isNotEmpty) ||
      (type != RecurrenceType.weekly && daysOfWeek == null),
  'Invalid Cycle configuration for type $type'
  );

  ENTCycle.daily()
      : this(type: RecurrenceType.daily);

  ENTCycle.weekly(Set<int> daysOfWeek)
      : this(
      type: RecurrenceType.weekly,
      daysOfWeek: daysOfWeek
  );

  bool get requiresDaysOfWeek => type == RecurrenceType.weekly;
}