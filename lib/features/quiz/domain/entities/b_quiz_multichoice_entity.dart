import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';

class ENTQuizMultiChoice extends ENTQuiz {
  final List<String> correctAnswer;

  ENTQuizMultiChoice({
    required super.id,
    required super.question,
    required this.correctAnswer,
    required super.options,
  });

  @override
  String get tag => 'MultiChoiceQuiz';

  @override
  bool check(dynamic answerUser) {
    if (answerUser.length != correctAnswer.length) return false;
    for (int i = 0; i < answerUser.length; i++) {
      if(!correctAnswer.contains(answerUser[i])) return false;
    }
    return true;
  }

  bool checkSingle(String answer) {
    return correctAnswer.contains(answer);
  }
}
