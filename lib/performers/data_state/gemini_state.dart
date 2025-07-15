import 'package:performer/performer.dart';

abstract class GeminiState extends DataState {
  const GeminiState();

  @override
  List<Object?> get props => [];
}

class GeminiInitialState extends GeminiState {
  const GeminiInitialState();

  @override
  List<Object?> get props => [];
}

class GeminiProgressState extends GeminiState {
  const GeminiProgressState();

  @override
  List<Object?> get props => [];
}

class GeminiDoneState extends GeminiState {
  final String answers;

  const GeminiDoneState(this.answers);

  @override
  List<Object?> get props => [answers];
}

class GeminiErrorState extends GeminiState {
  final String? message;

  const GeminiErrorState([this.message]);

  @override
  List<Object?> get props => [message];
}
