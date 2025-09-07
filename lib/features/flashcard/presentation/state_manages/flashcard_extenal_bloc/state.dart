import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';

abstract class FlashCardExtenalState {}

class FlashCardExtenalLoading extends FlashCardExtenalState {}

class FlashCardExtenalLoaded extends FlashCardExtenalState {
  final ENTFlashcardSet flashcardSet;
  FlashCardExtenalLoaded({required this.flashcardSet});
}

class FlashCardExtenalError extends FlashCardExtenalState {}