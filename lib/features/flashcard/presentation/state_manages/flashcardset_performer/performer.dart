import 'package:performer/performer.dart';
import 'package:smart_learn/features/flashcard/presentation/state_manages/flashcardset_performer/state.dart';

class FlashcardSetPerformer extends Performer<FlashcardSetState> {
  FlashcardSetPerformer() : super(data: const FlashCardSetInit());
}