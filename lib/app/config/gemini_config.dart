import 'package:zent_gemini/gemini_config.dart';
import 'package:zent_gemini/gemini_service.dart';

class GeminiAIConfig {
  static const String apiKey = 'AIzaSyAO8Eb1LBlguaf6LWD6Qkk8j5LxhKsn2H8';

  static GeminiAI gemAI(String model) => GeminiAI(GeminiConfig(
    apiKey: apiKey,
    model: model
  ));
}