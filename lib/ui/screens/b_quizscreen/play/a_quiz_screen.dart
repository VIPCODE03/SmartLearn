import 'package:flutter/material.dart';
import 'package:smart_learn/data/models/quiz/a_quiz.dart';
import 'package:smart_learn/ui/screens/b_quizscreen/play/b_quiz_review.dart';

class QuizScreen extends StatelessWidget {
  final Widget quiz;

  QuizScreen.review({super.key, required String jsonQuiz})
      : quiz = QuizReviewScreen(quizs: Quiz.fromJson(jsonQuiz));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.design_services),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: quiz,
    );
  }
}
