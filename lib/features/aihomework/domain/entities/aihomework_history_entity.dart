class ENTAIHomeWorkHistory {
  final String id;
  final String textQuestion;
  final String? imagePath;
  final String textAnswer;
  final DateTime createdAt;

  ENTAIHomeWorkHistory({
    required this.id,
    required this.textQuestion,
    this.imagePath,
    required this.textAnswer,
    required this.createdAt,
  });
}