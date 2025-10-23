import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/calendar/domain/entities/a_calendar_entity.dart';
import '../../features/calendar/domain/entities/zz_cycle_entity.dart';


class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  /// Khởi tạo plugin và xin quyền thông báo
  static Future<void> init() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(initSettings);
    tz.initializeTimeZones();

    // Xin quyền
    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  /// Xóa toàn bộ thông báo (dùng khi clear lịch)
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Tạo thông báo cho 1 ENTCalendar
  static Future<void> scheduleCalendar(ENTCalendar calendar) async {
    if (!_initialized) await init();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'calendar_channel',
        'Calendar Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    switch (calendar.cycle?.type ?? RecurrenceType.none) {
      case RecurrenceType.none:
        await _plugin.zonedSchedule(
          calendar.hashCode,
          calendar.title,
          'Đến giờ: ${calendar.title}',
          tz.TZDateTime.from(calendar.start, tz.local),
          details,
          androidScheduleMode: AndroidScheduleMode.alarmClock,
        );
        break;

      case RecurrenceType.daily:
        await _plugin.zonedSchedule(
          calendar.hashCode,
          calendar.title,
          'Đến giờ: ${calendar.title}',
          _nextInstanceOfTime(calendar.start),
          details,
          matchDateTimeComponents: DateTimeComponents.time,
          androidScheduleMode: AndroidScheduleMode.alarmClock,
        );
        break;

      case RecurrenceType.weekly:
        for (final day in calendar.cycle!.daysOfWeek!) {
          final schedule = _nextInstanceOfWeekday(calendar.start, day);
          await _plugin.zonedSchedule(
            calendar.hashCode + day,
            calendar.title,
            'Nhắc lịch: ${calendar.title}',
            schedule,
            details,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            androidScheduleMode: AndroidScheduleMode.alarmClock,
          );
        }
        break;
    }
  }

  /// Hủy thông báo của một event cụ thể
  static Future<void> cancelCalendar(ENTCalendar calendar) async {
    await _plugin.cancel(calendar.hashCode);
  }

  // ===== Helpers =====
  static tz.TZDateTime _nextInstanceOfTime(DateTime time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static tz.TZDateTime _nextInstanceOfWeekday(DateTime base, int weekday) {
    tz.TZDateTime scheduled = _nextInstanceOfTime(base);
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
