import 'package:performer/main.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';

abstract class FlashcardSetState extends DataState {
  const FlashcardSetState();
}

abstract class FlashCardSetNoData extends FlashcardSetState {
  const FlashCardSetNoData();

  @override
  List<Object?> get props => [];
}

class FlashCardSetInit extends FlashCardSetNoData {
  const FlashCardSetInit();
}

class FlashCardSetLoading extends FlashCardSetNoData {
  const FlashCardSetLoading();
}

class FlashcardManageErrorState extends FlashCardSetNoData {
  final String? message;
  const FlashcardManageErrorState({this.message});

  @override
  List<Object?> get props => [message];
}

//-----------

abstract class FlashCardSetHasData extends FlashcardSetState {
  final List<ENTFlashcardSet> cardSets;
  const FlashCardSetHasData(this.cardSets);

  @override
  List<Object?> get props => [cardSets];
}

class FlashCardSetLoaded extends FlashCardSetHasData {
  const FlashCardSetLoaded(super.cardSets);
}

class FlashCardSetAddError extends FlashCardSetHasData {
  const FlashCardSetAddError(super.cardSets);
}

class FlashCardSetUpdateError extends FlashCardSetHasData {
  const FlashCardSetUpdateError(super.cardSets);
}

class FlashCardSetDeleteError extends FlashCardSetHasData {
  const FlashCardSetDeleteError(super.cardSets);
}