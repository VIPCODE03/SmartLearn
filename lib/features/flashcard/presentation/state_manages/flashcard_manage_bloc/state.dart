
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';

abstract class FlashCardState {}


abstract class FlashCardNoDataState extends FlashCardState {}

class FlashCardInitialState extends FlashCardNoDataState {}

class FlashCardLoadingState extends FlashCardNoDataState {}

class FlashCardErrorState extends FlashCardNoDataState {}


abstract class FlashCardHasDataState extends FlashCardState {
  final List<ENTFlashCard> cards;
  FlashCardHasDataState(this.cards);
}

class FlashCardLoadedState extends FlashCardHasDataState {
  FlashCardLoadedState(super.cards);
}

class FlashCardCreatingState extends FlashCardHasDataState {
  FlashCardCreatingState(super.cards);
}

class FlashCardCompletedState extends FlashCardHasDataState {
  FlashCardCompletedState(super.cards);
}

class FlashCardFaildState extends FlashCardHasDataState {
  FlashCardFaildState(super.cards);
}