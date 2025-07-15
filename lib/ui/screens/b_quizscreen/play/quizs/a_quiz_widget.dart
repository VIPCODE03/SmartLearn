import 'package:flutter/cupertino.dart';
import 'package:smart_learn/data/models/quiz/b_choice_quiz.dart';
import 'package:smart_learn/data/models/quiz/b_multi_choice_quiz.dart';

import '../../../../../data/models/quiz/a_quiz.dart';
import 'b_multichoice_quiz_widget.dart';
import 'b_onechoice_quiz_widget.dart';


abstract class WdgQuiz<Q extends Quiz> extends StatefulWidget {
  final Q quiz;
  final dynamic userAnswer;
  final void Function(dynamic answer)? onAnswered;
  final bool testMode;

  const WdgQuiz({super.key,
    required this.quiz,
    this.userAnswer,
    this.onAnswered,
    this.testMode = true,
  });

  @override
  State<WdgQuiz<Q>> createState();

  static WdgQuiz build(Quiz quiz,
      {
        dynamic userAnswer,
        void Function(dynamic answer)? onAnswered,
        bool? isTestMode
      }) {
    switch(quiz) {
      case OneChoiceQuiz _: {
        return WdgOneChoiceQuiz(
          key: ValueKey(quiz),
          quiz: quiz,
          userAnswer: userAnswer,
          onAnswered: onAnswered,
          testMode: isTestMode ?? true,
        );
      }

      case MultiChoiceQuiz _: {
        return WdgMultiChoiceQuiz(
          key: ValueKey(quiz),
          quiz: quiz,
          userAnswer: userAnswer,
          onAnswered: onAnswered,
          testMode: isTestMode ?? true,
        );
      }
    }
    throw Exception();
  }
}
