
class Flashcard {
  final String front;
  final String back;

  Flashcard({required this.front, required this.back});

  Map<String, String> toMap() {
    return {
      'front': front,
      'back': back,
    };
  }

  factory Flashcard.fromMap(Map<String, String> map) {
    return Flashcard(
      front: map['front'] ?? '',
      back: map['back'] ?? '',
    );
  }
}
