import 'package:zent_gemini/gemini_config.dart';
import 'package:zent_gemini/gemini_service.dart';

class GeminiAIConfig {
  static const String apiKey = 'AIzaSyBwQDMZO8sx4dYcEXMWuQad-eqf1CnEFQ8';

  static GeminiAI gemAI(String model) => GeminiAI(GeminiConfig(
    apiKey: apiKey,
    model: model
  ));
}