import 'dart:typed_data';

abstract class ASKAIEvent {}

class ASKAI extends ASKAIEvent {
  final String textQuestion;
  final Uint8List? imageBytes;
  final String? instruct;

  ASKAI({
    required this.textQuestion,
    this.imageBytes,
    this.instruct,
  });
}

class LoadFromHistory extends ASKAIEvent {
  final String answer;
  LoadFromHistory(this.answer);
}