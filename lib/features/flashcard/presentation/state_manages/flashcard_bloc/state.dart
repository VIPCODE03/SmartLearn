import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';

abstract class FlashCardState {}

abstract class FlashCardNoData extends FlashCardState {}

class FlashCardLoading extends FlashCardNoData {}

class FlashCardError extends FlashCardNoData {}

abstract class FlashCardHasData extends FlashCardState {
  final int totalDontRemember;
  final int totalRemember;
  final int currentIndex;
  final int total;
  FlashCardHasData({
    required this.totalDontRemember,
    required this.totalRemember,
    required this.currentIndex,
    required this.total,
  });
}

class FlashCardCurrent extends FlashCardHasData {
  final ENTFlashCard card;
  FlashCardCurrent({
    required this.card,
    required super.totalDontRemember,
    required super.totalRemember,
    required super.currentIndex,
    required super.total
  });
}

class FlashCardCompleted extends FlashCardHasData {
  FlashCardCompleted({
    required super.totalDontRemember,
    required super.totalRemember,
    required super.currentIndex,
    required super.total
  });
}