import 'dart:typed_data';
import 'package:smart_learn/config/gemini_config.dart';
import 'package:smart_learn/constants/gemini_models.dart';
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import 'package:performer/performer.dart';
import 'package:zent_gemini/gemini_config.dart';
import 'package:zent_gemini/gemini_models.dart';
import 'package:zent_gemini/gemini_service.dart';

import '../../utils/assets_util.dart';

abstract class GeminiAction extends ActionUnit<GeminiState> {
  late final GeminiAI gemAI;
  final String model;

  static final Map<String, GeminiAI> _geminiInstances = {};

  GeminiAction(this.model, {bool forceNew = true}) {
    if (!forceNew && _geminiInstances.containsKey(model)) {
      gemAI = _geminiInstances[model]!;
    } else {
      gemAI = GeminiAI(GeminiConfig(
        apiKey: GeminiAIConfig.apiKey,
        model: model,
      ));
      _geminiInstances[model] = gemAI;
    }
  }
}

class GemTranslate extends GeminiAction {
  final String originalText;
  final String targetLanguage;

  GemTranslate({required this.originalText, required this.targetLanguage}) : super(GeminiModels.flash1_5);

  @override
  Stream<GeminiState> execute(GeminiState current) async* {
    try {
      yield const GeminiProgressState();
      String intructFormat = await UTIAssets.loadString(UTIAssets.path.train.translate);
      gemAI.setSystemInstruction = intructFormat;
      Content? answer = await gemAI.generateContent(await Content.build(textPrompt:
      'NỘI DUNG CẦN DỊCH:'
          '\noriginalText: $originalText'
          '\ntargetLanguage: $targetLanguage'));
      if (answer != null) {
        yield GeminiDoneState(answer);
      }
      else {
        yield const GeminiErrorState();
      }
    }
    catch (e) {
      yield const GeminiErrorState();
    }
  }
}

class GemChat extends GeminiAction {
  final String mess;
  final Uint8List? image;
  final Uint8List? pdf;
  final List<Content>? histories;

  GemChat({
    required this.mess,
    this.image,
    this.pdf,
    this.histories
  }) : super(GeminiModels.flash2_0);

  @override
  Stream<GeminiState> execute(GeminiState current) async* {
    try {
      if(histories != null) {
        gemAI.setHistory = histories!;
      }
      yield const GeminiProgressState();
      gemAI.setSystemInstruction = 'Cuộc trò chuyện với User';
      gemAI.setGoogleSearch = true;
      final Content? result;
      result = await gemAI.sendMessage(await Content.build(textPrompt: mess, image: image, pdf: pdf));
      if (result != null) {
        yield GeminiDoneState(result);
      }
      else {
        yield const GeminiErrorState();
      }
    }
    catch(e) {
      yield const GeminiErrorState();
    }
  }
}