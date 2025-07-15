
import 'package:smart_learn/performers/data_state/flashcard_manage.dart';
import 'package:performer/performer.dart';

class FlashcardPerformer extends Performer<FlashcardManageState> {
  FlashcardPerformer() : super(data: const FlashcardManageInitialState());
}