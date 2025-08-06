
import 'package:smart_learn/features/quiz/data/models/a_quiz_model.dart';
import 'package:smart_learn/features/quiz/domain/entities/c_quiz_result_entity.dart';

class MODQuizResult extends ENTQuizResult {
  MODQuizResult({
    required super.quizs,
    required super.userAnswers,
    required super.quizTotal,
    required super.correctTotal,
    required super.wrongTotal
  });

  Map<String, dynamic> toMap() {
    return {
      'quizs': quizs.map((e) => MODQuiz.fromEntity(e).toMap).toList(),
      'userAnswers': userAnswers,
      'quizTotal': quizTotal,
      'correctTotal': correctTotal,
      'wrongTotal': wrongTotal,
    };
  }

  factory MODQuizResult.fromMap(Map<String, dynamic> map) {
    return MODQuizResult(
      quizs: map['quizs'].map((e) => MODQuiz.fromMap(e)).toList(),
      userAnswers: map['userAnswers'],
      quizTotal: map['quizTotal'],
      correctTotal: map['correctTotal'],
      wrongTotal: map['wrongTotal'],
    );
  }
}