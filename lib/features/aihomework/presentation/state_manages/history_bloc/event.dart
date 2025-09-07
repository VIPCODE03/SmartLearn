import 'package:smart_learn/features/aihomework/domain/parameters/aihomework_history_params.dart';

abstract class AIHomeWorkHistoryEvent {}

class AIHomeWorkHistoryDelete extends AIHomeWorkHistoryEvent {
  final PARAIHomeWorkHistoryDelete params;
  AIHomeWorkHistoryDelete(this.params);
}

class AIHomeWorkHistoryGet extends AIHomeWorkHistoryEvent {
  final PARAIHomeWorkHistoryGet params;
  AIHomeWorkHistoryGet(this.params);
}