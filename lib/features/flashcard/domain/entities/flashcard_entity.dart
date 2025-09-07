///
/// [id] - id của flashcard
/// [flashCardSetId] - id của set flashcard
/// [front] - mặt trước
/// [back] - mặt sau
/// [rememberLevel] - mức độ nhớ -1: chưa biết, 0: chưa nhớ, 1: đã nhớ
///
class ENTFlashCard {
  static const int unknown = -1;
  static const int dontRemember = 0;
  static const int remember = 1;

  final String id;
  final String flashCardSetId;
  final String front;
  final String back;
  final int rememberLevel;

  ENTFlashCard({
    required this.id,
    required this.flashCardSetId,
    required this.front,
    required this.back,
    this.rememberLevel = unknown,
  });

  bool get isRemember => rememberLevel == remember;
  bool get isDontRemember => rememberLevel == dontRemember;
  bool get isUnknown => rememberLevel == unknown;
}
