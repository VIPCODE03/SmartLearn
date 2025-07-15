
import 'package:performer/main.dart';
import 'package:smart_learn/data/models/quiz/a_quiz.dart';
import 'package:smart_learn/performers/data_state/gemini_state.dart';

abstract class QuizManageState extends DataState{
  final List<Quiz> quizList;

  const QuizManageState({required this.quizList});
}

class QuizManageInitState extends QuizManageState {
  QuizManageInitState() : super(quizList: []);

  @override
  List<Object?> get props => [quizList];
}

class QuizManageLoadedState extends QuizManageState {
  const QuizManageLoadedState({required super.quizList});

  @override
  List<Object?> get props => [quizList];
}

class QuizManageCreatingByAIState extends QuizManageState {
  final GeminiState geminiState;
  const QuizManageCreatingByAIState({required super.quizList, required this.geminiState});

  @override
  List<Object?> get props => [quizList, geminiState];
}

