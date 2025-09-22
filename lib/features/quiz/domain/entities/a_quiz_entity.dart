
abstract class ENTQuiz {
  final String id;
  final String question;
  final List<dynamic> options;

  ENTQuiz({
    required this.id,
    required this.question,
    required this.options,
  });

  String get tag;

  bool check(dynamic answerUser);
}