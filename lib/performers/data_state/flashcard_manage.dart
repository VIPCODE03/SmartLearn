
import 'package:performer/main.dart';
import 'package:smart_learn/data/models/flashcard/a_flashcardset.dart';

abstract class FlashcardManageState extends DataState {
  const FlashcardManageState();
}

class FlashcardManageInitialState extends FlashcardManageState {
  const FlashcardManageInitialState();

  @override
  List<Object?> get props => [];
}

class FlashcardManageLoadingState extends FlashcardManageState {
  @override
  List<Object?> get props => [];
}

class FlashcardManageLoadedState extends FlashcardManageState {
  final List<FlashcardSet> cards;

  const FlashcardManageLoadedState(this.cards);

  @override
  List<Object?> get props => [cards];
}

class FlashcardManageErrorState extends FlashcardManageState {
  final String? message;
  const FlashcardManageErrorState({this.message});

  @override
  List<Object?> get props => [message];
}