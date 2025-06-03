import 'a_quiz.dart';
import 'b_choice_quiz.dart';
import 'b_multi_choice_quiz.dart';

class QuizRegister {
  static final Map<String, Quiz Function(Map<String, dynamic>)> _registeredList = {
    'OneChoiceQuiz': OneChoiceQuiz.fromMap,
    'MultiChoiceQuiz': MultiChoiceQuiz.fromMap,
  };

  static void register(String tag, Quiz Function(Map<String, dynamic>) factory) {
    _registeredList[tag] = factory;
  }

  static Map<String, Quiz Function(Map<String, dynamic>)> getRegisteredList() => _registeredList;
}