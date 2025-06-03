
import 'a_reminder.dart';

class ReminderRegister {
  static final Map<String, Reminder Function(Map<String, dynamic>)> _registeredList = {
  };

  static void register(String tag, Reminder Function(Map<String, dynamic>) factory) {
    _registeredList[tag] = factory;
  }

  static Map<String, Reminder Function(Map<String, dynamic>)> getRegisteredList() => _registeredList;
}