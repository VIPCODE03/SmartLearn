import 'package:smart_learn/core/database/tables/flashcard_table.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';

class MODFlashCard extends ENTFlashCard {

  MODFlashCard({
    required super.id,
    required super.flashCardSetId,
    required super.front,
    required super.back
  });

  Map<String, dynamic> toMap() {
    final table = FlashCardTable.instance;
    return {
      table.columnId: id,
      table.columnCardSetId: flashCardSetId,
      table.columnFront: front,
      table.columnBack: back,
    };
  }

  factory MODFlashCard.fromMap(Map<String, dynamic> map) {
    final table = FlashCardTable.instance;
    return MODFlashCard(
      id: map[table.columnId] as String,
      flashCardSetId: map[table.columnCardSetId] as String,
      front: map[table.columnFront] as String,
      back: map[table.columnBack] as String,
    );
  }

  MODFlashCard.fromEntity(ENTFlashCard flashCard) : super(
      id: flashCard.id,
      flashCardSetId: flashCard.flashCardSetId,
      front: flashCard.front,
      back: flashCard.back
  );
}