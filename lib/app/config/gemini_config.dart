import 'package:zent_gemini/gemini_config.dart';
import 'package:zent_gemini/gemini_service.dart';

class GeminiAIConfig {
  static const String apiKey = 'AIzaSyB5IhksV3GcQtl193PhCHrimFu4t6BuF8g';

  static GeminiAI gemAI(String model) => GeminiAI(GeminiConfig(
    apiKey: apiKey,
    model: model
  ));
}