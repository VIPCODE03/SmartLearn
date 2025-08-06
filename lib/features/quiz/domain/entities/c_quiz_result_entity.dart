import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';

class ENTQuizResult {
  final List<ENTQuiz> quizs;
  final Map<int, dynamic> userAnswers;
  final int quizTotal;
  final int correctTotal;
  final int wrongTotal;

  ENTQuizResult({
    required this.quizs,
    required this.userAnswers,
    required this.quizTotal,
    required this.correctTotal,
    required this.wrongTotal,
  });
}