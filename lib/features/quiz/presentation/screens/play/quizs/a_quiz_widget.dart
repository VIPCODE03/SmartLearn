import 'package:flutter/cupertino.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_multichoice_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_onechoice_entity.dart';
import 'b_multichoice_quiz_widget.dart';
import 'b_onechoice_quiz_widget.dart';

abstract class WIDQuiz<Q extends ENTQuiz> extends StatefulWidget {
  final Q quiz;
  final dynamic userAnswer;
  final void Function(dynamic answer)? onAnswered;
  final bool testMode;

  const WIDQuiz({super.key,
    required this.quiz,
    this.userAnswer,
    this.onAnswered,
    this.testMode = true,
  });

  @override
  State<WIDQuiz<Q>> createState();

  static WIDQuiz build(ENTQuiz quiz,
      {
        dynamic userAnswer,
        void Function(dynamic answer)? onAnswered,
        bool? isTestMode
      }) {
    switch(quiz) {
      case ENTQuizOneChoice _: {
        return WIDQuizOneChoice(
          key: ValueKey(quiz),
          quiz: quiz,
          userAnswer: userAnswer,
          onAnswered: onAnswered,
          testMode: isTestMode ?? true,
        );
      }

      case ENTQuizMultiChoice _: {
        return WIDQuizMultiChoice(
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
