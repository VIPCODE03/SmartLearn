import 'package:performer/main.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/c_quiz_result_entity.dart';

abstract class QuizPlayState extends DataState{
  final List<ENTQuiz> quizs;
  final Map<int, dynamic> userAnswers;

  const QuizPlayState({ required this.quizs, required this.userAnswers});
}

class QuizInitState extends QuizPlayState {
  const QuizInitState()
      : super(quizs: const [], userAnswers: const {});

  @override
  List<Object?> get props => [];
}

class QuizStateProgress extends QuizPlayState {
  final bool isCompleted;
  const QuizStateProgress({
    required this.isCompleted,
    required super.quizs,
    required super.userAnswers,
  });

  @override
  List<Object?> get props => [userAnswers, quizs];
}

class QuizStateCompleted extends QuizPlayState {
  final ENTQuizResult quizResult;
  const QuizStateCompleted({
    required super.quizs,
    required this.quizResult,
    required super.userAnswers,
  });

  @override
  List<Object?> get props => [quizs, quizResult, userAnswers];
}