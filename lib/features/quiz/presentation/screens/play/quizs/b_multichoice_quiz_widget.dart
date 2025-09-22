import 'package:flutter/material.dart';
import 'package:smart_learn/app/style/appstyle.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_multichoice_entity.dart';

import 'a_quiz_widget.dart';

class WIDQuizMultiChoice extends WIDQuiz<ENTQuizMultiChoice> {
  const WIDQuizMultiChoice({
    super.key,
    required super.quiz,
    super.userAnswer,
    super.onAnswered,
    super.testMode
  });

  @override
  State<WIDQuiz<ENTQuizMultiChoice>> createState() => _WdgMultiChoiceQuizState();
}

class _WdgMultiChoiceQuizState extends State<WIDQuizMultiChoice> {
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
    final color = context.style.color;

    return Padding(
      padding: const EdgeInsets.all(6),
      child: ListView(
        children: [
          ...List.generate(widget.quiz.options.length, (index) {
            String answer = widget.quiz.options[index];
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
                      ? color.primaryColor.withAlpha(15)
                      : Colors.grey.withAlpha(10),
                  border: Border.all(
                      width: 2,
                      color: color.primaryColor.withAlpha(50)
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                      color: isSelected ? color.primaryColor : Colors.grey,
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