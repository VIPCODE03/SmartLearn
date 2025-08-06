import 'dart:convert';

import 'package:smart_learn/core/database/tables/quiz_table.dart';
import 'package:smart_learn/features/quiz/data/models/a_quiz_model.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_onechoice_entity.dart';

QuizTable get _table => QuizTable.instance;

class MODQuizOneChoice extends ENTQuizOneChoice with MODQuizMixin implements MODQuiz {
  MODQuizOneChoice({
    required super.id,
    required super.question,
    required super.correctAnswer,
    required super.answers
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
      id: map[_table.columnId],
      question: map[_table.columnQuestion],
      correctAnswer: map[_table.columnChildProperties],
      answers: List<dynamic>.from(jsonDecode(map[_table.columnAnswers])),
    );
  }

  factory MODQuizOneChoice.fromEntity(ENTQuizOneChoice entity) {
    return MODQuizOneChoice(
      id: entity.id,
      question: entity.question,
      correctAnswer: entity.correctAnswer,
      answers: entity.answers,
    );
  }
}