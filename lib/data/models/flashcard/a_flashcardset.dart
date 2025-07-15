import 'b_flash_card.dart';

class FlashcardSet {
  final String id;
  final String name;
  final bool isSelect;
  final List<Flashcard> cards;

  FlashcardSet({
    required this.id,
    required this.name,
    required this.cards,
    this.isSelect = false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isSelect': isSelect,
      'cards': cards.map((card) => card.toMap()).toList(),
    };
  }

  factory FlashcardSet.fromMap(Map<String, dynamic> map) {
    final cardData = map['cards'] as List<dynamic>? ?? [];

    return FlashcardSet(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isSelect: map['isSelect'] ?? false,
      cards: cardData.map((cardMap) => Flashcard.fromMap(cardMap)).toList(),
    );
  }
}
