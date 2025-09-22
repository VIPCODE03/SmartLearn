import 'dart:convert';
import 'package:smart_learn/app/assets/app_assets.dart';
import 'package:smart_learn/app/config/gemini_config.dart';
import 'package:smart_learn/core/error/exeption.dart';
import 'package:smart_learn/features/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:smart_learn/features/quiz/data/models/a_quiz_model.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_params.dart';
import 'package:smart_learn/utils/json_util.dart';
import 'package:zent_gemini/gemini_models.dart';

abstract class ADSQuiz {
  Future<List<MODQuiz>> getQuizzesAI(String instruct, {required ForeignKeyParams foreign});
}

class ADSQuizImpl implements ADSQuiz {
  final LDSQuiz _localDataSource = LDSQuizImpl();

  @override
  Future<List<MODQuiz>> getQuizzesAI(String instruct, {required ForeignKeyParams foreign}) async {
    List<MODQuiz> quizzes = [];

    final gemAI = GeminiAIConfig.gemAI('gemini-2.5-flash');
    String intructFormat = await AppAssets.loadString(AppAssets.path.train.quiz);
    gemAI.setSystemInstruction = intructFormat;

    final result = await gemAI.generateContent(await Content.build(textPrompt: instruct));
    if(result != null && result.text != null) {
      final json = jsonDecode(UTIJson.cleanRawJsonString(result.text!));
      if(json is List) {
        quizzes = json.map((e) => MODQuiz.fromJson(e as Map<String, dynamic>)).toList();
        for(final quiz in quizzes) {
          await _localDataSource.add(quiz, foreign: foreign);
        }
        return quizzes;
      }
      else if(json is Map) {
        quizzes.add(MODQuiz.fromJson(json as Map<String, dynamic>));
        await _localDataSource.add(quizzes.first, foreign: foreign);
        return quizzes;
      }
      throw const FormatException();
    }
    else {
      throw const AIException();
    }
  }
}
