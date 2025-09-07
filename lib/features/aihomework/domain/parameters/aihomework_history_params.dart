
import 'package:smart_learn/features/aihomework/domain/entities/aihomework_history_entity.dart';

abstract class PARAIHomeWorkHistory {}

class PARAIHomeWorkHistoryAdd extends PARAIHomeWorkHistory {
  final String textQuestion;
  final String? imagePath;
  final String textAnswer;

  PARAIHomeWorkHistoryAdd({
    required this.textQuestion,
    this.imagePath,
    required this.textAnswer,
  });
}

class PARAIHomeWorkHistoryUpdate extends PARAIHomeWorkHistory {
  final ENTAIHomeWorkHistory history;
  final String? textQuestion;
  final String? imagePath;
  final String? textAnswer;

  PARAIHomeWorkHistoryUpdate(
    this.history, {
      this.textQuestion,
      this.imagePath,
      this.textAnswer,
  });
}

class PARAIHomeWorkHistoryDelete extends PARAIHomeWorkHistory {
  final String id;
  PARAIHomeWorkHistoryDelete(this.id);
}

abstract class PARAIHomeWorkHistoryGet extends PARAIHomeWorkHistory {}

class PARAIHomeWorkHistoryGetAll extends PARAIHomeWorkHistoryGet {}