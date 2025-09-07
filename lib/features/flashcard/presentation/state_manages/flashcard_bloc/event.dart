import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';

abstract class FlashCardEvent {}

class FlashCardLoadBySetId extends FlashCardEvent {
  final String flashCardSetId;
  FlashCardLoadBySetId(this.flashCardSetId);
}

class ResetAll extends FlashCardEvent {}

class ReviewDontRememberEvent extends FlashCardEvent {}

class FlashCardBack extends FlashCardEvent {}

class FlashCardUpdateStatus extends FlashCardEvent {
  final int rememberLevel;
  final ENTFlashCard card;
  FlashCardUpdateStatus.dontRemember(this.card) : rememberLevel = ENTFlashCard.dontRemember;
  FlashCardUpdateStatus.remember(this.card) : rememberLevel = ENTFlashCard.remember;
}
