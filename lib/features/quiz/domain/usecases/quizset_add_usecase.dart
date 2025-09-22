import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_onechoice_entity.dart';
import 'package:smart_learn/features/quiz/domain/entities/b_quiz_multichoice_entity.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_add_params.dart';
import 'package:smart_learn/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

class UCEQuizAdd extends UseCase<ENTQuiz?, QuizAddParams> {
  final REPQuiz repository;
  UCEQuizAdd(this.repository);

  @override
  Future<Either<Failure, ENTQuiz?>> call(QuizAddParams params) async {
    final newQuizSet = switch(params) {
      AddQuizOneChoiceParams() => ENTQuizOneChoice(
        id: UTIGenerateID.random(),
        question: params.question,
        options: params.answers,
        correctAnswer: params.correctAnswer,
      ),

      AddQuizMultiChoiceParams() => ENTQuizMultiChoice(
        id: UTIGenerateID.random(),
        question: params.question,
        options: params.answers,
        correctAnswer: params.correctAnswer,
      ),
      _ => throw Exception('Unknown Quiz type: ${params.runtimeType}')
    };
    final result = await repository.add(newQuizSet, foreign: params.foreign);
    return result.fold(
        (fail) => Left(fail),
        (data) => data ? Right(newQuizSet) :  const Right(null)
    );
  }
}