import 'package:smart_learn/core/database/tables/flashcard_table.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

FlashCardTable get _table => FlashCardTable.instance;

class MODFlashCard extends ENTFlashCard {

  MODFlashCard({
    required super.id,
    required super.flashCardSetId,
    required super.front,
    required super.back,
    super.rememberLevel = ENTFlashCard.unknown,
  });

  Map<String, dynamic> toMap() {
    return {
      _table.columnId: id,
      _table.columnCardSetId: flashCardSetId,
      _table.columnFront: front,
      _table.columnBack: back,
      _table.columnRememberLevel: rememberLevel,
    };
  }

  factory MODFlashCard.fromMap(Map<String, dynamic> map) {
    return MODFlashCard(
      id: map[_table.columnId] as String,
      flashCardSetId: map[_table.columnCardSetId] as String,
      front: map[_table.columnFront] as String,
      back: map[_table.columnBack] as String,
      rememberLevel: map[_table.columnRememberLevel] as int,
    );
  }

  factory MODFlashCard.fromJson(Map<String, dynamic> json, String cardSetId) {
    return MODFlashCard(
      id: json[_table.columnId] ?? UTIGenerateID.random(),
      flashCardSetId: cardSetId,
      front: json[_table.columnFront] as String,
      back: json[_table.columnBack] as String,
    );
  }

  MODFlashCard.fromEntity(ENTFlashCard flashCard) : super(
      id: flashCard.id,
      flashCardSetId: flashCard.flashCardSetId,
      front: flashCard.front,
      back: flashCard.back,
      rememberLevel: flashCard.rememberLevel
  );
}