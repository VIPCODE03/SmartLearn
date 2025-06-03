import 'package:smart_learn/data/models/reminder/a_reminder.dart';

class PersonalTaskReminder extends Reminder {

  PersonalTaskReminder({
    required super.id,
    required super.title,
    required super.cycle,
    required super.startDate,
    required super.endDate
  });

  @override
  String get tag => 'PersonalTaskReminder';

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }

}