import 'package:bloc/bloc.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcardset_usecase/flashcardset_add_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcardset_usecase/flashcardset_get_usecase.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_extenal_bloc/event.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcard_extenal_bloc/state.dart';

class FlashCardExtenalBloc extends Bloc<FlashCardExtenalEvent, FlashCardExtenalState> {
  final UCEFlashCardSetAdd _add;
  final UCEFlashCardSetGet _get;
  FlashCardExtenalBloc(this._add, this._get) : super(FlashCardExtenalLoading()) {
    on<FlashCardExtenalLoadOrCreate>(_onGetOrCreate);
  }

  Future<void> _onGetOrCreate(FlashCardExtenalLoadOrCreate event, Emitter<FlashCardExtenalState> emit) async {
    emit(FlashCardExtenalLoading());
    final result = await _get(FlashCardSetGetByExtenalParams(event.params));
    if (result.isLeft()) {
      emit(FlashCardExtenalError());
      return;
    }
    else {
      final flashcardSet = result.getOrElse(() => null);
      if (flashcardSet == null) {
        final resultAdd = await _add(FlashCardSetAddParams(event.params, name: 'New Flashcard Set'));
        if (resultAdd.isLeft()) {
          emit(FlashCardExtenalError());
        } else {
          final newCardSet = resultAdd.getOrElse(() => throw Exception('Unexpected null'));
          emit(FlashCardExtenalLoaded(flashcardSet: newCardSet));
        }
      }
      else {
        emit(FlashCardExtenalLoaded(flashcardSet: flashcardSet));
      }
    }
  }
}