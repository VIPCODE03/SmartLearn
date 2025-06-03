
import 'package:performer/main.dart';
import 'package:smart_learn/data/models/quiz/a_quiz.dart';
import 'package:smart_learn/data/models/quiz/c_quiz_result.dart';

abstract class QuizState extends DataState{
  final List<Quiz> quizs;
  final Map<int, dynamic> userAnswers;

  const QuizState({ required this.quizs, required this.userAnswers});
}

class QuizInitState extends QuizState {
  const QuizInitState()
      : super(quizs: const [], userAnswers: const {});

  @override
  List<Object?> get props => [];
}

class QuizStateProgress extends QuizState {
  final bool isCompleted;
  const QuizStateProgress({
    required this.isCompleted,
    required super.quizs,
    required super.userAnswers,
  });

  @override
  List<Object?> get props => [userAnswers, quizs];
}

class QuizStateCompleted extends QuizState {
  final QuizResult quizResult;
  const QuizStateCompleted({
    required super.quizs,
    required this.quizResult,
    required super.userAnswers,
  });

  @override
  List<Object?> get props => [quizs, quizResult, userAnswers];
}