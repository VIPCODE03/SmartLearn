import 'package:smart_learn/features/flashcard/domain/parameters/flashcard_params.dart';

abstract class FlashCardEvent {}

class AddFlashCardEvent extends FlashCardEvent {
  final FlashCardAddParams params;
  AddFlashCardEvent(this.params);
}

class AIFlashcardEvent extends FlashCardEvent {
  final FlashCardGetWithAIParams params;
  AIFlashcardEvent(this.params);
}

class UpdateFlashCardEvent extends FlashCardEvent {
  final FlashCardUpdateParams params;
  UpdateFlashCardEvent(this.params);
}

class DeleteFlashCardEvent extends FlashCardEvent {
  final FlashCardDeleteParams params;
  DeleteFlashCardEvent(this.params);
}

class GetAllFlashCardEvent extends FlashCardEvent {
  final FlashCardGetAllParams params;
  GetAllFlashCardEvent(this.params);
}