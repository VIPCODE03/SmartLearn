import 'a_quiz.dart';

class MultiChoiceQuiz extends Quiz {
  final List<String> correctAnswer;

  MultiChoiceQuiz({
    required super.question,
    required this.correctAnswer,
    required super.answers,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...toMapBase(),
      'correctAnswer': correctAnswer,
    };
  }

  factory MultiChoiceQuiz.fromMap(Map<String, dynamic> map) {
    return MultiChoiceQuiz(
      question: map['question'],
      correctAnswer: List<String>.from(map['correctAnswer']),
      answers: map['answers'],
    );
  }

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
    if(correctAnswer.contains(answer)) return true;
    return false;
  }
}
