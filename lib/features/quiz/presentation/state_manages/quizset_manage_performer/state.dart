import 'package:performer/main.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';

abstract class QuizManageState extends DataState{
  const QuizManageState();
}

abstract class QuizManageNoDataState extends QuizManageState {
  const QuizManageNoDataState();

  @override
  List<Object?> get props => [];
}

class QuizManageInitState extends QuizManageNoDataState {
  const QuizManageInitState();
}

class QuizError extends QuizManageNoDataState {
  const QuizError();
}

abstract class QuizManageHasDataState extends QuizManageState {
  final List<ENTQuiz> quizzes;
  const QuizManageHasDataState({required this.quizzes});

  @override
  List<Object?> get props => [quizzes];
}

class CreatedQuiz extends QuizManageHasDataState {
  const CreatedQuiz({required super.quizzes});
}

class QuizLoaded extends QuizManageHasDataState {
  const QuizLoaded({required super.quizzes});
}

class CreatingQuizByAI extends QuizManageHasDataState {
  const CreatingQuizByAI({required super.quizzes});
}

class CreatedQuizByAI extends QuizManageHasDataState {
  final List<ENTQuiz> newQuizzes;
  const CreatedQuizByAI({required super.quizzes, required this.newQuizzes});

  @override
  List<Object?> get props => [...super.props, newQuizzes];
}