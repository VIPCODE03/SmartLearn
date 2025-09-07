import 'package:smart_learn/config/gemini_config.dart';
import 'package:smart_learn/utils/assets_util.dart';
import 'package:zent_gemini/gemini_models.dart';
import 'package:zent_gemini/gemini_service.dart';

class SERGeminiAnalysis {
  final GeminiAI _geminiAI;

  static SERGeminiAnalysis get instance => _instance;
  static final SERGeminiAnalysis _instance = SERGeminiAnalysis._extenal();
  SERGeminiAnalysis._extenal() : _geminiAI = GeminiAIConfig.gemAI('gemini-2.0-flash');

  Future<String?> analysis(String data, String analysisGuide) async {
    final String instruct = await UTIAssets.loadString(UTIAssets.path.train.analysis);
    final Content? answer = await _geminiAI.generateContent(await Content.build(textPrompt: ''
        'Hướng dẫn: $instruct'
        'Dữ liệu: $data'
        'Hướng dẫn phân tích: $analysisGuide'
    ));
    if(answer != null && answer.text != null) {
      return answer.text;
    }
    return null;
  }
}