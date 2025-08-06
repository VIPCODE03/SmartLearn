import 'package:flutter/material.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';
import 'package:smart_learn/global.dart';

extension SubjectUI on ENTSubject {
  String get evaluateName {
    final average = averageCore;
    if (average < 4 && average >= 0) {
      return globalLanguage.poor;
    } else if (average >= 4 && average < 6.5) {
      return globalLanguage.average;
    } else if (average >= 6.5 && average < 8.2) {
      return globalLanguage.quiteGood;
    } else if(average >= 8.2 && average <= 10){
      return globalLanguage.good;
    }
    return '';
  }

  Color get evaluateColor {
    final average = averageCore;
    if (average < 4 && average >= 0) {
      return Colors.red;
    } else if (average >= 4 && average < 6.5) {
      return Colors.deepOrange;
    } else if (average >= 6.5 && average < 8.2) {
      return Colors.blue;
    } else if(average >= 8.2 && average <= 10){
      return Colors.green;
    }
    return Colors.grey;
  }
}