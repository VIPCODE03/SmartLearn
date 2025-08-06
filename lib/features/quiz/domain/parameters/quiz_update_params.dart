import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_multichoice_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_onechoice_entity.dart';

abstract class QuizUpdateParams<T extends ENTQuiz> {
  final T quiz;
  final String? question;
  final List<dynamic>? answers;

  QuizUpdateParams(this.quiz, {this.question, this.answers});
}

class QuizOneChoiceUpdateParams extends QuizUpdateParams<ENTQuizOneChoice> {
  final String? correctAnswer;
  QuizOneChoiceUpdateParams(super.quiz, {super.question, super.answers, this.correctAnswer});
}

class QuizMultiChoiceUpdateParams extends QuizUpdateParams<ENTQuizMultiChoice> {
  final List<String>? correctAnswer;
  QuizMultiChoiceUpdateParams(super.quiz, {super.question, super.answers, this.correctAnswer});
}