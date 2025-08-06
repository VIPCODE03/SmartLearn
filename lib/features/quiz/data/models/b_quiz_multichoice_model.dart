import 'dart:convert';

import 'package:smart_learn/core/database/tables/quiz_table.dart';
import 'package:smart_learn/features/quiz/data/models/a_quiz_model.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_multichoice_entity.dart';

QuizTable get _table => QuizTable.instance;

class MODQuizMultiChoice extends ENTQuizMultiChoice with MODQuizMixin implements MODQuiz {
  MODQuizMultiChoice({
    required super.id,
    required super.question,
    required super.correctAnswer,
    required super.answers,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...toMapBase(),
      _table.columnChildProperties: jsonEncode(correctAnswer),
    };
  }

  factory MODQuizMultiChoice.fromMap(Map<String, dynamic> map) {
    return MODQuizMultiChoice(
      id: map[_table.columnId],
      question: map[_table.columnQuestion],
      correctAnswer: List<String>.from(jsonDecode(map[_table.columnChildProperties])),
      answers: List<dynamic>.from(jsonDecode(map[_table.columnAnswers])),
    );
  }

  factory MODQuizMultiChoice.fromEntity(ENTQuizMultiChoice entity) {
    return MODQuizMultiChoice(
      id: entity.id,
      question: entity.question,
      correctAnswer: entity.correctAnswer,
      answers: entity.answers,
    );
  }
}