import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';

abstract class FlashCardExtenalEvent {}

class FlashCardExtenalLoadOrCreate extends FlashCardExtenalEvent {
  final FlashCardSetForeignParams params;
  FlashCardExtenalLoadOrCreate({required this.params});
}