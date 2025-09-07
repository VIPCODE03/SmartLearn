
abstract class PARCycle {}

class PARCycleNone extends PARCycle {}

class PARCycleDaily extends PARCycle {}

class PARCycleWeekly extends PARCycle {
  final Set<int> daysOfWeek;
  PARCycleWeekly(this.daysOfWeek);
}