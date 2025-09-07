import 'package:bloc/bloc.dart';
import 'package:smart_learn/features/aihomework/domain/usecases/aihomework_history_delete_usecase.dart';
import 'package:smart_learn/features/aihomework/domain/usecases/aihomework_history_get_usecase.dart';
import 'package:smart_learn/features/aihomework/presentation/state_manages/history_bloc/event.dart';
import 'package:smart_learn/features/aihomework/presentation/state_manages/history_bloc/state.dart';

class AIHomeWorkBloc extends Bloc<AIHomeWorkHistoryEvent, AIHomeWorkHistoryState> {
  final UCEAIHomeWorkHistoryGet getHistory;
  final UCEAIHomeWorkHistoryDelete deleteHistory;

  AIHomeWorkBloc({required this.getHistory, required this.deleteHistory}) : super(AIHomeWorkHistoryInit()) {
    on<AIHomeWorkHistoryGet>(_onGetHistory);
    on<AIHomeWorkHistoryDelete>(_onDeleteHistory);
  }

  void _onGetHistory(AIHomeWorkHistoryGet event, Emitter<AIHomeWorkHistoryState> emit) async {
    emit(AIHomeWorkHistoryLoading());
    final result = await getHistory(event.params);
    result.fold(
      (fail) => emit(AIHomeWorkHistoryError()),
      (data) => emit(AIHomeWorkHistoryLoaded(data))
    );
  }

  void _onDeleteHistory(AIHomeWorkHistoryDelete event, Emitter<AIHomeWorkHistoryState> emit) async {
    if(state is AIHomeWorkHistoryHasData) {
      final currentState = state as AIHomeWorkHistoryHasData;
      emit(AIHomeWorkUpdating(currentState.histories));
      final result = await deleteHistory(event.params);
      result.fold(
        (fail) => emit(AIHomeWorkHistoryError()),
        (sucsess) {
          if(sucsess) {
            final historiesUpdated = currentState.histories.where((element) => element.id != event.params.id).toList();
            emit(AIHomeWorkHistoryLoaded(historiesUpdated));
          }
          else {
            emit(AIHomeWorkHistoryUpdateError(currentState.histories));
          }
        }
      );
    }
  }
}