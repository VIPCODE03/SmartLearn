
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import 'package:performer/performer.dart';

class GeminiPerformer extends Performer<GeminiState> {
  GeminiPerformer() : super(data: const GeminiInitialState());
}