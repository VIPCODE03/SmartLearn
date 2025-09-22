import 'dart:convert';

import 'package:smart_learn/core/database/tables/quiz_table.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/features/quiz/data/models/b_quiz_multichoice_model.dart';
import 'package:smart_learn/features/quiz/data/models/b_quiz_onechoice_model.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_multichoice_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_onechoice_entity.dart';

QuizTable get _table => QuizTable.instance;

mixin MODQuizMixin {
  String get id;
  String get question;
  List<dynamic> get options;
  String get tag;

  Map<String, dynamic> toMapBase() {
    return {
      _table.columnId: id,
      _table.columnQuestion: question,
      _table.columnOptions: jsonEncode(options),
      _table.columnTag: tag,
    };
  }
}

abstract class MODQuiz extends ENTQuiz {
  MODQuiz({
    required super.id,
    required super.question,
    required super.options,
  });

  Map<String, dynamic> toMap();

  factory MODQuiz.fromMap(Map<String, dynamic> map) {
    switch (map[_table.columnTag]) {
      case 'OneChoiceQuiz': return MODQuizOneChoice.fromMap(map);
      case 'MultiChoiceQuiz': return MODQuizMultiChoice.fromMap(map);
      default: throw Exception('Unknown Quiz type: ${map['tag']}');
    }
  }

  factory MODQuiz.fromJson(Map<String, dynamic> json) {
    switch (json[_table.columnTag]) {
      case 'OneChoiceQuiz': return MODQuizOneChoice.fromJson(json);
      case 'MultiChoiceQuiz': return MODQuizMultiChoice.fromJson(json);
      default: throw Exception('Unknown Quiz type: ${json['tag']}');
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