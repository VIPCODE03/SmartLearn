import 'package:smart_learn/core/database/tables/aihomework_table.dart';
import 'package:smart_learn/features/aihomework/domain/entities/aihomework_history_entity.dart';

AIHomeWorkTable get _table => AIHomeWorkTable.instance;

class MODAIHomeWorkHistory extends ENTAIHomeWorkHistory {
  MODAIHomeWorkHistory({
    required super.id,
    required super.textQuestion,
    super.imagePath,
    required super.textAnswer,
    required super.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      _table.columnId: id,
      _table.columnTextQuestion: textQuestion,
      _table.columnImagePath: imagePath,
      _table.columnTextAnswer: textAnswer,
      _table.columnCreatedAt: createdAt.toIso8601String(),
    };
  }

  factory MODAIHomeWorkHistory.fromJson(Map<String, dynamic> json) {
    return MODAIHomeWorkHistory(
      id: json[_table.columnId],
      textQuestion: json[_table.columnTextQuestion],
      imagePath: json[_table.columnImagePath],
      textAnswer: json[_table.columnTextAnswer],
      createdAt: DateTime.parse(json[_table.columnCreatedAt]),
    );
  }

  factory MODAIHomeWorkHistory.fromEntity(ENTAIHomeWorkHistory entity) {
    return MODAIHomeWorkHistory(
      id: entity.id,
      textQuestion: entity.textQuestion,
      imagePath: entity.imagePath,
      textAnswer: entity.textAnswer,
      createdAt: entity.createdAt,
    );
  }
}