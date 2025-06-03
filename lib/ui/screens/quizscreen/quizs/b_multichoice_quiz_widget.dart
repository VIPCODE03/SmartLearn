import 'package:flutter/material.dart';
import 'package:smart_learn/data/models/quiz/b_multi_choice_quiz.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/ui/screens/quizscreen/quizs/a_quiz_widget.dart';

class WdgMultiChoiceQuiz extends WdgQuiz<MultiChoiceQuiz> {
  const WdgMultiChoiceQuiz({
    super.key,
    required super.quiz,
    super.userAnswer,
    super.onAnswered,
    super.testMode
  });

  @override
  State<WdgQuiz<MultiChoiceQuiz>> createState() => _WdgOneChoiceQuizState();
}

class _WdgOneChoiceQuizState extends State<WdgMultiChoiceQuiz> {
  List<String> selected = [];

  @override
  void initState() {
    super.initState();
    if(widget.userAnswer != null) {
      selected = widget.userAnswer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ListView(children: [
        ...List.generate(widget.quiz.answers.length, (index) {
          String answer = widget.quiz.answers[index];
          return GestureDetector(
              onTap: () {
                setState(() {
                  if(selected.contains(answer)) {
                    selected.remove(answer);
                  }
                  else {
                    selected.add(answer);
                  }
                  if(widget.onAnswered != null) {
                    widget.onAnswered!(selected);
                  }
                });
              },
              child: Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints(minHeight: 50),
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: selected.contains(answer)
                        ? primaryColor(context).withAlpha(66)
                        : Colors.grey.withAlpha(66),
                    border: Border.all(
                        width: 2,
                        color: !widget.testMode && widget.quiz.checkSingle(answer)
                            ? Colors.green
                            : Colors.transparent
                    )
                ),
                child: Text(answer),
              )
          );
        })
      ]),
    );
  }
}