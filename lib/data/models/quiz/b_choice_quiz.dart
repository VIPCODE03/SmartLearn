import 'a_quiz.dart';

class OneChoiceQuiz extends Quiz {
  final String correctAnswer;

  OneChoiceQuiz({
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

  factory OneChoiceQuiz.fromMap(Map<String, dynamic> map) {
    return OneChoiceQuiz(
      question: map['question'],
      correctAnswer: map['correctAnswer'],
      answers: List<String>.from(map['answers']),
    );
  }

  @override
  String get tag => 'OneChoiceQuiz';

  @override
  bool check(dynamic answerUser) {
    return answerUser == correctAnswer;
  }
}
