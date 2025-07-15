
class Time {
  final int hour;
  final int minute;

  const Time({required this.hour, required this.minute})
      : assert(hour >= 0 && hour < 24, 'Hour must be between 0 and 23'),
        assert(minute >= 0 && minute < 60, 'Minute must be between 0 and 59');

  Map<String, dynamic> toMap() {
    return {'hour': hour, 'minute': minute};
  }

  factory Time.fromMap(Map<String, dynamic> map) {
    return Time(
      hour: map['hour'] as int,
      minute: map['minute'] as int,
    );
  }

  factory Time.now() {
    final now = DateTime.now();
    return Time(hour: now.hour, minute: now.minute);
  }

  int _toTotalMinutes() {
    return hour * 60 + minute;
  }

  int differenceInMinutes(Time otherTime) {
    int startMinutes = _toTotalMinutes();
    int endMinutes = otherTime._toTotalMinutes();
    if (endMinutes < startMinutes) {
      endMinutes += 24 * 60;
    }

    return endMinutes - startMinutes;
  }

  bool isBefore(Time otherTime) {
    return _toTotalMinutes() < otherTime._toTotalMinutes();
  }

  bool isAfter(Time otherTime) {
    return _toTotalMinutes() > otherTime._toTotalMinutes();
  }

  int compareTo(Time otherTime) {
    return _toTotalMinutes().compareTo(otherTime._toTotalMinutes());
  }

  String get formatHHMM => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  String toString() => 'Time($hour:$minute)';
}