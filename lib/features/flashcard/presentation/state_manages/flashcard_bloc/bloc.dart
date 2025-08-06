
import 'package:bloc/bloc.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_add_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_delete_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_get_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_update_usecase.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_bloc/events.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_bloc/state.dart';

class FlashCardBloc extends Bloc<FlashCardEvent, FlashCardState> {
  final UCEFlashCardAdd addUseCase = getIt();
  final UCEFlashCardUpdate updateUseCase = getIt();
  final UCEFlashCardDelete deleteUseCase = getIt();
  final UCEFlashCardGet getUseCase = getIt();

  FlashCardBloc() : super(FlashCardInitialState()) {
    on<AddFlashCardEvent>(_onAdd);
    on<UpdateFlashCardEvent>(_onUpdate);
    on<DeleteFlashCardEvent>(_onDelete);
    on<GetAllFlashCardEvent>(_onGet);
  }

  void _onAdd(AddFlashCardEvent event, Emitter<FlashCardState> emit) async {
    if(state is FlashCardHasDataState) {
      final currentState = state as FlashCardHasDataState;
      final result = await addUseCase(event.params);
      result.fold(
            (fail) => emit(FlashCardFaildState(currentState.cards)),
            (flashCard) => emit(FlashCardCompletedState([...currentState.cards, flashCard])),
      );
    }
  }

  void _onUpdate(UpdateFlashCardEvent event, Emitter<FlashCardState> emit) async {
    if(state is FlashCardHasDataState) {
      final currentState = state as FlashCardHasDataState;
      final result = await updateUseCase(event.params);
      result.fold(
            (fail) => emit(FlashCardFaildState(currentState.cards)),
            (flashCard) {
              final index = currentState.cards.indexWhere((card) => card.id == flashCard.id);
              if (index != -1) {
                final newCards = [...currentState.cards];
                newCards[index] = flashCard;
                emit(FlashCardCompletedState(newCards));
              }
            },
      );
    }
  }

  void _onDelete(DeleteFlashCardEvent event, Emitter<FlashCardState> emit) async {
    if(state is FlashCardHasDataState) {
      final currentState = state as FlashCardHasDataState;
      final result = await deleteUseCase(event.params);
      result.fold(
            (fail) => emit(FlashCardFaildState(currentState.cards)),
            (completed) {
              if (completed) {
                final newCards = currentState.cards.where((card) => card.id != event.params.id).toList();
                emit(FlashCardCompletedState(newCards));
              }
            }
      );
    }
  }

  void _onGet(GetAllFlashCardEvent event, Emitter<FlashCardState> emit) async {
    emit(FlashCardLoadingState());
    final result = await getUseCase(event.params);
    result.fold(
          (fail) => emit(FlashCardErrorState()),
          (cards) => emit(FlashCardLoadedState(cards)),
    );
  }
}