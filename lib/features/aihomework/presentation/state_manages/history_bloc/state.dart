
import 'package:smart_learn/features/aihomework/domain/entities/aihomework_history_entity.dart';

abstract class AIHomeWorkHistoryState {}

abstract class AIHomeWorkHistoryNoData extends AIHomeWorkHistoryState {}

class AIHomeWorkHistoryInit extends AIHomeWorkHistoryNoData {}

class AIHomeWorkHistoryLoading extends AIHomeWorkHistoryNoData {}

class AIHomeWorkHistoryError extends AIHomeWorkHistoryNoData {}

abstract class AIHomeWorkHistoryHasData extends AIHomeWorkHistoryState {
  final List<ENTAIHomeWorkHistory> histories;
  AIHomeWorkHistoryHasData(this.histories);
}

class AIHomeWorkHistoryLoaded extends AIHomeWorkHistoryHasData {
  AIHomeWorkHistoryLoaded(super.histories);
}

class AIHomeWorkUpdating extends AIHomeWorkHistoryHasData {
  AIHomeWorkUpdating(super.histories);
}

class AIHomeWorkHistoryUpdateError extends AIHomeWorkHistoryHasData {
  AIHomeWorkHistoryUpdateError(super.histories);
}