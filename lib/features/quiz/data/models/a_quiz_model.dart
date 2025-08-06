import 'dart:convert';

import 'package:smart_learn/core/database/tables/quiz_table.dart';
import 'package:smart_learn/features/quiz/data/models/b_quiz_multichoice_model.dart';
import 'package:smart_learn/features/quiz/data/models/b_quiz_onechoice_model.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_multichoice_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_onechoice_entity.dart';

QuizTable get _table => QuizTable.instance;

mixin MODQuizMixin {
  String get id;
  String get question;
  List<dynamic> get answers;
  String get tag;

  Map<String, dynamic> toMapBase() {
    return {
      _table.columnId: id,
      _table.columnQuestion: question,
      _table.columnAnswers: jsonEncode(answers),
      _table.columnTag: tag,
    };
  }
}

abstract class MODQuiz extends ENTQuiz {
  MODQuiz({
    required super.id,
    required super.question,
    required super.answers,
  });

  Map<String, dynamic> toMap();

  factory MODQuiz.fromMap(Map<String, dynamic> map) {
    switch (map[_table.columnTag]) {
      case 'onechoice': return MODQuizOneChoice.fromMap(map);
      case 'multichoice': return MODQuizMultiChoice.fromMap(map);
      default: throw Exception('Unknown Quiz type: ${map['tag']}');
    }
  }

  factory MODQuiz.fromEntity(ENTQuiz entity) {
    switch (entity) {
      case ENTQuizOneChoice _: return MODQuizOneChoice.fromEntity(entity);
      case ENTQuizMultiChoice _: return MODQuizMultiChoice.fromEntity(entity);
      default: throw Exception('Unknown Quiz type: ${entity.runtimeType}');
    }
  }
}