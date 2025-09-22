import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_get_params.dart';
import 'package:smart_learn/features/quiz/domain/repositories/quiz_repository.dart';

class UCEQuizSetGet extends UseCase<List<ENTQuiz>, QuizGetParams> {
  final REPQuiz repository;
  UCEQuizSetGet(this.repository);

  @override
  Future<Either<Failure, List<ENTQuiz>>> call(QuizGetParams params) async {
    switch(params) {
      case QuizGetAllParams _:
        return repository.getAll(foreign: params.foreign);
      case QuizGetByIdParams _:
        final quizSet = await repository.getById(params.id);
        return quizSet.fold(
            (fail) => Left(fail),
            (quizSet) => quizSet != null ? Right([quizSet]) : const Right([])
        );
      default:
        throw ArgumentError('Invalid parameters type for UCEQuizSetGet');
    }
  }
}