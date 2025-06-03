import 'dart:convert';

import 'a_quiz_resgister.dart';

abstract class Quiz {
  String question;
  List<dynamic> answers;

  String get tag;

  Quiz({
    required this.question,
    required this.answers,
  });

  bool check(dynamic answerUser);

  Map<String, dynamic> toMapBase() {
    return {
      'question': question,
      'answers': answers,
      'tag': tag,
    };
  }

  Map<String, dynamic> toMap();

  factory Quiz.fromMap(Map<String, dynamic> map) {
    String tag = map['tag'];
    if (QuizRegister.getRegisteredList().containsKey(tag)) {
      return QuizRegister.getRegisteredList()[tag]!(map);
    } else {
      throw UnimplementedError('Quiz tag "$tag" not implemented');
    }
  }

  static List<Quiz> fromJson(String json) {
    dynamic convert = jsonDecode(json);
    if(convert is Map<String, dynamic>) {
      return [Quiz.fromMap(convert)];
    }
    else if(convert is List) {
      List<Quiz> quizs = [];
      for(var data in convert) {
        quizs.add(Quiz.fromMap(data));
      }
      return quizs;
    }
    return [];
  }
}