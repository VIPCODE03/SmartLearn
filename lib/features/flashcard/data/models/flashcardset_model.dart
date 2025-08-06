import 'package:smart_learn/core/database/tables/flashcard_table.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';

class MODFlashCardSet extends ENTFlashcardSet {
  MODFlashCardSet({required super.id, required super.name, required super.isSelect});

  Map<String, dynamic> toMap() {
    final table = FlashcardSetTable.instance;
    return {
      table.columnId: id,
      table.columnName: name,
      table.columnIsSelect: isSelect ? 1 : 0,
    };
  }

  factory MODFlashCardSet.fromMap(Map<String, dynamic> map) {
    final table = FlashcardSetTable.instance;
    return MODFlashCardSet(
      id: map[table.columnId] as String,
      name: map[table.columnName] as String,
      isSelect: map[table.columnIsSelect] == 1 ? true : false
    );
  }

  MODFlashCardSet.fromEntity(ENTFlashcardSet flashcardSet) : super(
      id: flashcardSet.id,
      name: flashcardSet.name,
      isSelect: flashcardSet.isSelect
  );
}