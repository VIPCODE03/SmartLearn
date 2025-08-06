
import 'package:week_of_year/date_week_extensions.dart';

class UTIDateTime {
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static String getFormatHHmm(DateTime time) {
    return "${time.hour < 10 ? '0' : ''}${time.hour}:${time.minute < 10 ? '0' : ''}${time.minute}";
  }

  static int getWeekNumber(DateTime date) {
    return date.weekOfYear;
  }

  static int daysBetweenCeil(DateTime from, DateTime to) {
    final diff = to.difference(from);
    return (diff.inSeconds / Duration.secondsPerDay).ceil().abs();
  }

  static int dayToInt(DateTime date) {
    return int.parse(dayToString(date));
  }

  static String dayToString(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  }
}