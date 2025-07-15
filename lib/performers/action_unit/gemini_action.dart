
import 'package:image_cropper/image_cropper.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import 'package:performer/performer.dart';
import 'package:smart_learn/utils/json_util.dart';
import 'package:zent_gemini/gemini_config.dart';
import 'package:zent_gemini/gemini_service.dart';

import '../../constants/gemini_constant.dart';
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
        apiKey: 'AIzaSyBwQDMZO8sx4dYcEXMWuQad-eqf1CnEFQ8',
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

  AskAction({required this.topic, required this.instruct, required this.question}) : super(GeminiModels.flash2_0);

  @override
  Stream<GeminiState> execute(GeminiState current) async* {
    try {
      yield const GeminiProgressState();
      String intructFormat = await UtilAssets.loadString(UtilAssets.path.train.format);
      String intructMission = await UtilAssets.loadString(UtilAssets.path.train.mission);

      gemAI.setSystemInstruction = ""
          "mission: $intructMission"
          "\njson format: $intructFormat"
          "\nCác thông tin user đã bổ sung: "
          "\n+ mong muốn: $instruct"
          "\n+ chủ đề: $topic"
          "";

      String newQuestion;
      String? answers;
      if (question is String) {
        newQuestion = 'Trả lời câu hỏi: $question';
        answers = await gemAI.generateContent(newQuestion);
      } else {
        newQuestion = 'Giải bài trong ảnh';
        answers = await gemAI.generateContentWithImage(newQuestion, (question as CroppedFile).path);
      }

      if(answers != null) {
        yield GeminiDoneState(JsonUtil.cleanRawJsonString(answers));
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
      String intructFormat = await UtilAssets.loadString(UtilAssets.path.train.quiz);
      gemAI.setSystemInstruction = intructFormat;
      String? answers = await gemAI.generateContent(
          'Mong muốn từ user: $instruct'
      );
      if (answers != null) {
        yield GeminiDoneState(JsonUtil.cleanRawJsonString(answers));
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
    Map<String, String>? translates = translateds[originalText];
    if (translateds.containsKey(originalText) && translates != null && translates.containsKey(targetLanguage)) {
      yield GeminiDoneState(translates[targetLanguage]!);
    }
    else {
      try {
        yield const GeminiProgressState();
        String intructFormat = await UtilAssets.loadString(UtilAssets.path.train.translate);
        gemAI.setSystemInstruction = intructFormat;
        String? answer = await gemAI.generateContent(''
            'NỘI DUNG CẦN DỊCH:'
            '\noriginalText: $originalText'
            '\ntargetLanguage: $targetLanguage'
        );
        if (answer != null) {
          // if(translateds.containsKey(originalText)) {
          //   translateds[originalText]![targetLanguage] = answer;
          // }
          // else {
          //   translateds[originalText] = {targetLanguage: answer};
          // }
          yield GeminiDoneState(JsonUtil.cleanRawJsonString(answer));
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
}

class GemChat extends GeminiAction {
  final String mess;

  GemChat({required this.mess}) : super(GeminiModels.flash2_0, forceNew: false);

  @override
  Stream<GeminiState> execute(GeminiState current) async* {
    try {
      yield const GeminiProgressState();
      gemAI.setSystemInstruction = 'Cuộc trò chuyện với User';
      String? answer = await gemAI.sendMessage(
          'Tin nhắn từ user: $mess'
      );
      if (answer != null) {
        yield GeminiDoneState(answer);
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