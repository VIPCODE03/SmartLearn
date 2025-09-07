import 'package:performer/main.dart';
import 'package:smart_learn/core/di/injection.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcardset_usecase/flashcardset_add_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcardset_usecase/flashcardset_delete_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcardset_usecase/flashcardset_get_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcardset_usecase/flashcardset_update_usecase.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcardset_performer/state.dart';

abstract class FlashCardManageAction extends ActionUnit<FlashcardSetState> {
  final UCEFlashCardSetAdd add;
  final UCEFlashCardSetUpdate update;
  final UCEFlashCardSetDelete delete;
  final UCEFlashCardSetGetList get;
  FlashCardManageAction()
      : add = getIt(),
        update = getIt(),
        delete = getIt(),
        get = getIt();
}

class FlashCardSetLoadAll extends FlashCardManageAction {
  final FlashCardSetGetAllParams loadAllParams;
  FlashCardSetLoadAll(this.loadAllParams);

  @override
  Stream<FlashcardSetState> execute(FlashcardSetState current) async* {
    yield const FlashCardSetLoading();
    await Future.delayed(const Duration(seconds: 1));
    final result = await get(loadAllParams);
    yield result.fold(
            (fail) => const FlashcardManageErrorState(message: 'Đã xảy ra lỗi'),
            (datas) => FlashCardSetLoaded(datas)
    );
  }
}

class FlashCardSetAdd extends FlashCardManageAction {
  final FlashCardSetAddParams addPramas;
  FlashCardSetAdd(this.addPramas);

  @override
  Stream<FlashcardSetState> execute(FlashcardSetState current) async* {
    if(current is FlashCardSetHasData) {
      final result = await add(addPramas);
      yield result.fold(
              (fail) => FlashCardSetAddError(current.cardSets),
              (datas) => FlashCardSetLoaded([...current.cardSets, datas])
      );
    }
  }
}

class FlashCardSetUpdate extends FlashCardManageAction {
  final FlashCardSetUpdateParams updateParams;
  FlashCardSetUpdate(this.updateParams);

  @override
  Stream<FlashcardSetState> execute(FlashcardSetState current) async* {
    if(current is FlashCardSetHasData) {
      final result = await update(updateParams);
      yield result.fold(
              (fail) => FlashCardSetUpdateError(current.cardSets),
              (data) {
                final newCards = List<ENTFlashcardSet>.from(current.cardSets);
                final index = newCards.indexWhere((element) => element.id == updateParams.flashcardSet.id);
                newCards[index] = data;
                return FlashCardSetLoaded(newCards);
              }
      );
    }
  }
}

class FlashCardSetDelete extends FlashCardManageAction {
  final FlashCardSetDeleteParams deleteParams;
  FlashCardSetDelete(this.deleteParams);

  @override
  Stream<FlashcardSetState> execute(FlashcardSetState current) async* {
    if(current is FlashCardSetHasData) {
      final result = await delete(deleteParams);
      yield result.fold(
              (fail) => FlashCardSetDeleteError(current.cardSets),
              (completed) {
                final newCards = List<ENTFlashcardSet>.from(current.cardSets);
                newCards.removeWhere((element) => element.id == deleteParams.id);
                return FlashCardSetLoaded(newCards);
              }
      );
    }
  }
}