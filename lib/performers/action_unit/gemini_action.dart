import 'dart:io';
import 'dart:typed_data';

import 'package:image_cropper/image_cropper.dart';
import 'package:smart_learn/config/gemini_config.dart';
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import 'package:performer/performer.dart';
import 'package:zent_gemini/gemini_config.dart';
import 'package:zent_gemini/gemini_models.dart';
import 'package:zent_gemini/gemini_service.dart';

import '../../utils/assets_util.dart';

class GeminiModels {
  //- Model 2.5 ----------------------------------------------------------------
  static const String pro2_5 = "gemini-2.5-pro";
  static const String flash2_5 = "gemini-2.5-flash";
  static const String flashLite2_5 = "gemini-2.5-flash-lite-preview-06-17";

  //- Model 2.0 ----------------------------------------------------------------
  static const String flash2_0 = "gemini-2.0-flash";
  static const String flashLite2_0 = "gemini-2.0-flash-lite";

  //- Model 1.5 ----------------------------------------------------------------
  static const String flash1_5 = "gemini-1.5-flash";
  static const String flashLite1_5 = "gemini-1.5-flash-8b";
  static const String pro1_5 = "gemini-1.5-pro";
}

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

class AskAction extends GeminiAction {
  final String topic;
  final String instruct;
  final dynamic question;

  AskAction({required this.topic, required this.instruct, required this.question}) : super(GeminiModels.pro2_5);

  @override
  Stream<GeminiState> execute(GeminiState current) async* {
    try {
      yield const GeminiProgressState();
      String intructFormat = await UTIAssets.loadString(UTIAssets.path.train.format);
      String intructMission = await UTIAssets.loadString(UTIAssets.path.train.mission);

      gemAI.setSystemInstruction = ""
          "mission: $intructMission"
          "\njson format: $intructFormat"
          "\nCác thông tin user đã bổ sung: "
          "\n+ mong muốn: $instruct"
          "\n+ chủ đề: $topic"
          "";

      String newQuestion;
      Content? answers;
      if (question is String) {
        newQuestion = 'Trả lời câu hỏi: $question';
        answers = await gemAI.generateContent(await Content.build(textPrompt: newQuestion));
      } else {
        newQuestion = 'Giải bài trong ảnh';
        final file = File((question as CroppedFile).path);
        final image = await file.readAsBytes();
        answers = await gemAI.generateContent(await Content.build(textPrompt: newQuestion, image: image));
      }

      if(answers != null) {
        yield GeminiDoneState(answers);
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

class CreateQuiz extends GeminiAction {
  final String instruct;
  final dynamic file;

  CreateQuiz({required this.instruct, this.file}) : super(GeminiModels.flash2_0);

  @override
  Stream<GeminiState> execute(GeminiState current) async* {
    try {
      yield const GeminiProgressState();
      String intructFormat = await UTIAssets.loadString(UTIAssets.path.train.quiz);
      gemAI.setSystemInstruction = intructFormat;
      Content? answers = await gemAI.generateContent(await Content.build(textPrompt: 'Mong muốn từ user: $instruct'));
      if (answers != null) {
        yield GeminiDoneState(answers);
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