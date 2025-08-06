import 'package:performer/main.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/c_quiz_result_entity.dart';
import 'package:smart_learn/features/quiz/presentation/state_manages/quiz_play_performer/quizplay_state.dart';

class StartQuiz extends ActionUnit<QuizPlayState> {
  final List<ENTQuiz> quizs;
  StartQuiz(this.quizs);

  @override
  Stream<QuizPlayState> execute(QuizPlayState current) async* {
    yield QuizStateProgress(quizs: quizs..shuffle(), userAnswers: const {}, isCompleted: false);
  }
}

class SaveQuiz extends ActionUnit<QuizPlayState> {
  final int currentQuiz;
  final dynamic userAnswer;

  SaveQuiz(this.currentQuiz, this.userAnswer);

  @override
  Stream<QuizPlayState> execute(QuizPlayState current) async* {
    final updatedMap = Map<int, dynamic>.from(current.userAnswers);
    updatedMap[currentQuiz] = userAnswer;

    yield QuizStateProgress(
        quizs: current.quizs,
        userAnswers: updatedMap,
        isCompleted: updatedMap.length == current.quizs.length ? true : false
    );
  }
}

class CompletedQuiz extends ActionUnit<QuizPlayState> {
  @override
  Stream<QuizPlayState> execute(QuizPlayState current) async* {
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
        quizResult: ENTQuizResult(
            quizs: current.quizs,
            userAnswers: current.userAnswers,
            quizTotal: current.quizs.length,
            correctTotal: correct,
            wrongTotal: wrong),
        userAnswers: current.userAnswers
    );
  }
}