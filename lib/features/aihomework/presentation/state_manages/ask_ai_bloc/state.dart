
abstract class ASKAIState {}

class ASKAIAnswering extends ASKAIState {}

class ASKAIAnswer extends ASKAIState {
  final String answer;
  ASKAIAnswer(this.answer);
}

class ASKAIError extends ASKAIState {
  final String? message;
  ASKAIError({this.message});
}