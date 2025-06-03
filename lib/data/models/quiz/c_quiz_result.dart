import 'package:smart_learn/data/models/quiz/a_quiz.dart';

class QuizResult {
  final List<Quiz> quizs;
  final Map<int, dynamic> userAnswers;
  final int quizTotal;
  final int correctTotal;
  final int wrongTotal;

  QuizResult({
    required this.quizs,
    required this.userAnswers,
    required this.quizTotal,
    required this.correctTotal,
    required this.wrongTotal,
  });
}