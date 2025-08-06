import 'package:flutter/material.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_onechoice_entity.dart';
import 'package:smart_learn/global.dart';

import 'a_quiz_widget.dart';

class WIDQuizOneChoice extends WIDQuiz<ENTQuizOneChoice> {
  const WIDQuizOneChoice({
    super.key,
    required super.quiz,
    super.userAnswer,
    super.onAnswered,
    super.testMode
  });

  @override
  State<WIDQuiz<ENTQuizOneChoice>> createState() => _WdgOneChoiceQuizState();
}

class _WdgOneChoiceQuizState extends State<WIDQuizOneChoice> {
  String selected = '';

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
                selected = answer;
                if(widget.onAnswered != null) {
                  widget.onAnswered!(answer);
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
                  color: answer == selected
                      ? primaryColor(context).withAlpha(50)
                      : Colors.grey.withAlpha(10),
                  border: Border.all(
                      width: 2,
                      color: primaryColor(context).withAlpha(50)
                  )
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),

                  Expanded(child: Text(
                    answer,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: answer == selected ? FontWeight.bold : null,
                        decoration: !widget.testMode && !widget.quiz.check(answer)
                            ? TextDecoration.lineThrough
                            : null
                    ),
                  )),

                  ///-  Icon đúng ---------------------------------------------
                  if (!widget.testMode && widget.quiz.check(answer))
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.check_circle, color: Colors.green),
                    ),
                ],
              )
            )
          );
        })
      ]),
    );
  }
}