
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import 'package:performer/performer.dart';

class GeminiConductor extends Performer<GeminiState> {
  GeminiConductor() : super(data: const GeminiState('', GemState.none));
}