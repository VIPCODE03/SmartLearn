import 'package:flutter/material.dart';
import 'package:smart_learn/data/models/reminder/a_reminder_register.dart';

abstract class Reminder {
  final int id;
  String title;
  Cycle cycle;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  String get tag;

  Reminder({
    required this.id,
    required this.title,
    required this.cycle,
    required this.startDate,
    required this.endDate,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toBaseMap() {
    return {
      "id": id,
      "title": title,
      "cycle": cycle,
      "startDate": startDate,
      "endDate": endDate,
      "startTime": startTime,
      "endTime": endTime,
      "tag": this
    };
  }

  Map<String, dynamic> toMap();

  factory Reminder.fromMap(Map<String, dynamic> map) {
    String tag = map['tag'];
    if (ReminderRegister.getRegisteredList().containsKey(tag)) {
      return ReminderRegister.getRegisteredList()[tag]!(map);
    } else {
      throw UnimplementedError('Reminder tag "$tag" not implemented');
    }
  }
}

enum Cycle {
  no,
  daily,
  weekly,
  monthly,
  yearly,
}