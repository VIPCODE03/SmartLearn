import 'package:smart_learn/features/quiz/domain/parameters/quiz_params.dart';

abstract class QuizAddParams extends QuizParams {
  final String question;
  final List<dynamic> answers;
  QuizAddParams(super.foreign, {required this.question, required this.answers});
}

class AddQuizOneChoiceParams extends QuizAddParams {
  final String correctAnswer;
  AddQuizOneChoiceParams(super.foreign, {required super.question, required super.answers, required this.correctAnswer});
}

class AddQuizMultiChoiceParams extends QuizAddParams {
  final List<String> correctAnswer;
  AddQuizMultiChoiceParams(super.foreign, {required super.question, required super.answers, required this.correctAnswer});
}
