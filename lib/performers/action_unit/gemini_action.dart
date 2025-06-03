
import 'package:image_cropper/image_cropper.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/performers/data_state/gemini_state.dart';
import 'package:performer/performer.dart';
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
      yield current.copyWith(state: GemState.progress);
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
        yield current.copyWith(state: GemState.done, answers: answers);
      }
      else {
        yield current.copyWith(state: GemState.error);
      }
    }
    catch(e) {
      yield current.copyWith(state: GemState.error);
    }
  }
}

class CreateQuiz extends GeminiAction {
  final String? nameSubject;
  final String? jsonQuizCurrent;
  final String instruct;
  final dynamic file;

  CreateQuiz({required this.instruct, this.nameSubject, this.jsonQuizCurrent, this.file}) : super(GeminiModels.flash2_0);

  @override
  Stream<GeminiState> execute(GeminiState current) async* {
    try {
      yield current.copyWith(state: GemState.progress);
      String intructFormat = await UtilAssets.loadString(UtilAssets.path.train.quiz);
      gemAI.setSystemInstruction = intructFormat;
      String? answers = await gemAI.generateContent(
          'Mong muốn từ user: $instruct'
      );
      if (answers != null) {
        yield current.copyWith(state: GemState.done, answers: answers);
      }
      else {
        yield current.copyWith(state: GemState.error);
      }
    }
    catch(e) {
      yield current.copyWith(state: GemState.error);
    }
  }
}

class GemTranslate extends GeminiAction {
  final String translate;
  final String language;

  GemTranslate({required this.translate, required this.language}) : super(GeminiModels.flash1_5);

  @override
  Stream<GeminiState> execute(GeminiState current) async* {
    Map<String, String>? translates = translateds[translate];
    if (translateds.containsKey(translate) && translates != null && translates.containsKey(language)) {
      yield current.copyWith(
          state: GemState.done,
          answers: translates[language]
      );
    }
    else {
      try {
        yield current.copyWith(state: GemState.progress);
        String intructFormat = await UtilAssets.loadString(UtilAssets.path.train.translate);
        gemAI.setSystemInstruction = intructFormat;
        String? answer = await gemAI.generateContent(''
            '\nVăn bản: $translate'
            '\nDịch sang: $language'
        );
        if (answer != null) {
          if(translateds.containsKey(translate)) {
            translateds[translate]![language] = answer;
          }
          else {
            translateds[translate] = {language: answer};
          }
          yield current.copyWith(state: GemState.done, answers: answer);
        }
        else {
          yield current.copyWith(state: GemState.error);
        }
      }
      catch (e) {
        yield current.copyWith(state: GemState.error);
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
      yield current.copyWith(state: GemState.progress);
      gemAI.setSystemInstruction = 'Cuộc trò chuyện với User';
      String? answer = await gemAI.sendMessage(
          'Tin nhắn từ user: $mess'
      );
      if (answer != null) {
        yield current.copyWith(state: GemState.done, answers: answer);
      }
      else {
        yield current.copyWith(state: GemState.error);
      }
    }
    catch(e) {
      yield current.copyWith(state: GemState.error);
    }
  }
}