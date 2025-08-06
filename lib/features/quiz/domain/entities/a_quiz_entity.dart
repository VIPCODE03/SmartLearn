
abstract class ENTQuiz {
  final String id;
  final String question;
  final List<dynamic> answers;

  ENTQuiz({
    required this.id,
    required this.question,
    required this.answers,
  });

  String get tag;

  bool check(dynamic answerUser);
}