import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_multichoice_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_onechoice_entity.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_update_params.dart';
import 'package:smart_learn/features/quiz/domain/repositories/quiz_repository.dart';

class UCEQuizSetUpdate extends UseCase<ENTQuiz, QuizUpdateParams> {
  final REPQuiz repository;
  UCEQuizSetUpdate(this.repository);

  @override
  Future<Either<Failure, ENTQuiz>> call(QuizUpdateParams params) async {
    final quizSetUpdated = switch(params) {
      QuizOneChoiceUpdateParams _ => ENTQuizOneChoice(
        id: params.quiz.id,
        question: params.question ?? params.quiz.question,
        correctAnswer: params.correctAnswer ?? params.quiz.correctAnswer,
        options: params.answers ?? params.quiz.options,
      ),

      QuizMultiChoiceUpdateParams _ => ENTQuizMultiChoice(
        id: params.quiz.id,
        question: params.question ?? params.quiz.question,
        correctAnswer: params.correctAnswer ?? params.quiz.correctAnswer,
        options: params.answers ?? params.quiz.options,
      ),

      QuizUpdateParams<ENTQuiz>() => throw UnimplementedError(),
    };
    final result = await repository.update(quizSetUpdated);
    return result.fold(
        (fail) => Left(fail),
        (completed) => completed ? Right(quizSetUpdated) : Left(CacheFailure())
    );
  }
}