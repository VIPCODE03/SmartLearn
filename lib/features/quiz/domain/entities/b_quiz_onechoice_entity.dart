import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';

class ENTQuizOneChoice extends ENTQuiz {
  final String correctAnswer;

  ENTQuizOneChoice({
    required super.id,
    required super.question,
    required this.correctAnswer,
    required super.options,
  });

  @override
  String get tag => 'OneChoiceQuiz';

  @override
  bool check(dynamic answerUser) {
    return answerUser == correctAnswer;
  }
}
