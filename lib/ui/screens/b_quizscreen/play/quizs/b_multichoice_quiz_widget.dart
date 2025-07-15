import 'package:flutter/material.dart';
import 'package:smart_learn/data/models/quiz/b_multi_choice_quiz.dart';
import 'package:smart_learn/global.dart';

import 'a_quiz_widget.dart';

class WdgMultiChoiceQuiz extends WdgQuiz<MultiChoiceQuiz> {
  const WdgMultiChoiceQuiz({
    super.key,
    required super.quiz,
    super.userAnswer,
    super.onAnswered,
    super.testMode
  });

  @override
  State<WdgQuiz<MultiChoiceQuiz>> createState() => _WdgMultiChoiceQuizState();
}

class _WdgMultiChoiceQuizState extends State<WdgMultiChoiceQuiz> {
  List<String> _selected = [];

  @override
  void initState() {
    super.initState();
    if(widget.userAnswer != null) {
      _selected = widget.userAnswer;
    }
  }

  bool _isCheckCorrect(String answer) {
    return _selected.contains(answer) && !widget.testMode;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ListView(
        children: [
          ...List.generate(widget.quiz.answers.length, (index) {
            String answer = widget.quiz.answers[index];
            bool isSelected = _selected.contains(answer);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if(isSelected) {
                    _selected.remove(answer);
                  } else {
                    _selected.add(answer);
                  }
                  if(widget.onAnswered != null) {
                    widget.onAnswered!(_selected);
                  }
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? primaryColor(context).withAlpha(15)
                      : Colors.grey.withAlpha(10),
                  border: Border.all(
                      width: 2,
                      color: primaryColor(context).withAlpha(50)
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                      color: isSelected ? primaryColor(context) : Colors.grey,
                    ),

                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        answer,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),

                    ///-  Icon đúng ---------------------------------------------
                    if (_isCheckCorrect(answer))
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.check_circle, color: Colors.green),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}