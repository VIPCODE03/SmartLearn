import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';

class FlashCardAddParams {
  final String front;
  final String back;
  final String cardSetId;
  FlashCardAddParams({ required this.front, required this.back, required this.cardSetId });
}

class FlashCardUpdateParams {
  final ENTFlashCard flashCard;
  final String? front;
  final String? back;
  final int? rememberLevel;

  FlashCardUpdateParams(this.flashCard,
      {
        this.front,
        this.back,
        this.rememberLevel
      });
}

class FlashCardMultiResetParams {
  final List<ENTFlashCard> cards;
  FlashCardMultiResetParams(this.cards);
}

class FlashCardDeleteParams {
  final String id;
  FlashCardDeleteParams(this.id);
}

abstract class FlashCardGetParams {
  final String cardSetId;
  FlashCardGetParams(this.cardSetId);
}

class FlashCardGetAllParams extends FlashCardGetParams {
  FlashCardGetAllParams(super.cardSetId);
}