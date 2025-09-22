import 'dart:convert';

import 'package:smart_learn/core/database/tables/quiz_table.dart';
import 'package:smart_learn/features/quiz/data/models/a_quiz_model.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_multichoice_entity.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

QuizTable get _table => QuizTable.instance;

class MODQuizMultiChoice extends ENTQuizMultiChoice with MODQuizMixin implements MODQuiz {
  MODQuizMultiChoice({
    required super.id,
    required super.question,
    required super.correctAnswer,
    required super.options,
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
      id: map[_table.columnId] as String,
      question: map[_table.columnQuestion] as String,
      correctAnswer: List<String>.from(jsonDecode(map[_table.columnChildProperties])),
      options: List<dynamic>.from(jsonDecode(map[_table.columnOptions])),
    );
  }

  factory MODQuizMultiChoice.fromJson(Map<String, dynamic> json) {
    return MODQuizMultiChoice(
      id: json[_table.columnId] ?? UTIGenerateID.random(),
      question: json[_table.columnQuestion],
      correctAnswer: List<String>.from((json[_table.columnChildProperties])),
      options: List<dynamic>.from((json[_table.columnOptions])),
    );
  }

  factory MODQuizMultiChoice.fromEntity(ENTQuizMultiChoice entity) {
    return MODQuizMultiChoice(
      id: entity.id,
      question: entity.question,
      correctAnswer: entity.correctAnswer,
      options: entity.options,
    );
  }
}