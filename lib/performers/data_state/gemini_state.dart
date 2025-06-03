
import 'package:performer/performer.dart';

class GeminiState extends DataState {
  final String answers;
  final GemState state;

  const GeminiState(this.answers, this.state);

  GeminiState copyWith({
    String? answers,
    GemState? state,
  }) {
    return GeminiState(
      answers ?? this.answers,
      state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [answers, state];
}

enum GemState {none, progress, done, error}