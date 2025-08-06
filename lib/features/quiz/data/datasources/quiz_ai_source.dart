import 'dart:convert';
import 'package:smart_learn/config/gemini_config.dart';
import 'package:smart_learn/core/error/exeption.dart';
import 'package:smart_learn/features/quiz/data/models/a_quiz_model.dart';
import 'package:smart_learn/utils/assets_util.dart';
import 'package:smart_learn/utils/json_util.dart';
import 'package:zent_gemini/gemini_models.dart';

abstract class ADSQuiz {
  Future<List<MODQuiz>> getQuizzesAI(String instruct);
}

class ADSQuizImpl implements ADSQuiz {
  @override
  Future<List<MODQuiz>> getQuizzesAI(String instruct) async {
    final gemAI = GeminiAIConfig.gemAI('gemini-2.5-flash');
    String intructFormat = await UTIAssets.loadString(UTIAssets.path.train.quiz);
    gemAI.setSystemInstruction = intructFormat;

    final result = await gemAI.generateContent(await Content.build(textPrompt: instruct));
    if(result != null && result.text != null) {
      final json = jsonDecode(UTIJson.cleanRawJsonString(result.text!));
      if(json is List<Map<String, dynamic>>) {
        return json.map((e) => MODQuiz.fromMap(e)).toList();
      }
      else if(json is Map<String, dynamic>) {
        return [MODQuiz.fromMap(json)];
      }
      throw const FormatException();
    }
    else {
      throw const AIException();
    }
  }
}
