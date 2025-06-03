
import 'package:performer/main.dart';
import 'package:smart_learn/data/models/quiz/c_quiz_result.dart';
import 'package:smart_learn/performers/data_state/quiz_state.dart';
import 'package:smart_learn/data/models/quiz/a_quiz.dart';

class StartQuiz extends ActionUnit<QuizState> {
  final List<Quiz> quizs;
  StartQuiz(this.quizs);

  @override
  Stream<QuizState> execute(QuizState current) async* {
    yield QuizStateProgress(quizs: quizs, userAnswers: const {}, isCompleted: false);
  }
}

class SaveQuiz extends ActionUnit<QuizState> {
  final int currentQuiz;
  final dynamic userAnswer;

  SaveQuiz(this.currentQuiz, this.userAnswer);

  @override
  Stream<QuizState> execute(QuizState current) async* {
    final updatedMap = Map<int, dynamic>.from(current.userAnswers);
    updatedMap[currentQuiz] = userAnswer;

    yield QuizStateProgress(
      quizs: current.quizs,
      userAnswers: updatedMap,
      isCompleted: updatedMap.length == current.quizs.length ? true : false
    );
  }
}

class CompletedQuiz extends ActionUnit<QuizState> {
  @override
  Stream<QuizState> execute(QuizState current) async* {
    int correct = 0;
    int wrong = 0;
    for(int i = 0; i < current.quizs.length; i++) {
      if(current.quizs[i].check(current.userAnswers[i])) {
        correct++;
      }
      else {
        wrong++;
      }
    }
    yield QuizStateCompleted(
        quizs: current.quizs,
        quizResult: QuizResult(
            quizs: current.quizs,
            userAnswers: current.userAnswers,
            quizTotal: current.quizs.length,
            correctTotal: correct,
            wrongTotal: wrong),
        userAnswers: current.userAnswers
    );
  }
}