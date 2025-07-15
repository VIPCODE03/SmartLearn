
class ENTTime {
  final int hour;
  final int minute;

  const ENTTime({required this.hour, required this.minute})
      : assert(hour >= 0 && hour < 24, 'Hour must be between 0 and 23'),
        assert(minute >= 0 && minute < 60, 'Minute must be between 0 and 59');

  factory ENTTime.now() {
    final now = DateTime.now();
    return ENTTime(hour: now.hour, minute: now.minute);
  }

  int _toTotalMinutes() {
    return hour * 60 + minute;
  }

  int differenceInMinutes(ENTTime otherTime) {
    int startMinutes = _toTotalMinutes();
    int endMinutes = otherTime._toTotalMinutes();
    if (endMinutes < startMinutes) {
      endMinutes += 24 * 60;
    }

    return endMinutes - startMinutes;
  }

  bool isBefore(ENTTime otherTime) {
    return _toTotalMinutes() < otherTime._toTotalMinutes();
  }

  bool isAfter(ENTTime otherTime) {
    return _toTotalMinutes() > otherTime._toTotalMinutes();
  }

  int compareTo(ENTTime otherTime) {
    return _toTotalMinutes().compareTo(otherTime._toTotalMinutes());
  }

  String get formatHHMM => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  String toString() => 'Time($hour:$minute)';
}