import 'dart:convert';

import 'package:smart_learn/core/database/tables/quiz_table.dart';
import 'package:smart_learn/features/quiz/data/models/a_quiz_model.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_onechoice_entity.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

QuizTable get _table => QuizTable.instance;

class MODQuizOneChoice extends ENTQuizOneChoice with MODQuizMixin implements MODQuiz {
  MODQuizOneChoice({
    required super.id,
    required super.question,
    required super.correctAnswer,
    required super.options
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...toMapBase(),
      _table.columnChildProperties: correctAnswer,
    };
  }

  factory MODQuizOneChoice.fromMap(Map<String, dynamic> map) {
    return MODQuizOneChoice(
      id: map[_table.columnId] as String,
      question: map[_table.columnQuestion] as String,
      correctAnswer: map[_table.columnChildProperties] as String,
      options: (jsonDecode(map[_table.columnOptions])) as List<dynamic>,
    );
  }

  factory MODQuizOneChoice.fromJson(Map<String, dynamic> json) {
    return MODQuizOneChoice(
      id: json[_table.columnId] ?? UTIGenerateID.random(),
      question: json[_table.columnQuestion] as String,
      correctAnswer: json[_table.columnChildProperties] as String,
      options: (json[_table.columnOptions]) as List<dynamic>,
    );
  }

  factory MODQuizOneChoice.fromEntity(ENTQuizOneChoice entity) {
    return MODQuizOneChoice(
      id: entity.id,
      question: entity.question,
      correctAnswer: entity.correctAnswer,
      options: entity.options,
    );
  }
}