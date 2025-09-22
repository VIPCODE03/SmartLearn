import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_create_ai_params.dart';
import 'package:smart_learn/features/quiz/domain/repositories/quiz_repository.dart';

class UCEQuizSetCreateQuizAI extends UseCase<List<ENTQuiz>, QuizCreateQuizAIParams> {
  final REPQuiz quizRepository;
  UCEQuizSetCreateQuizAI(this.quizRepository);

  @override
  Future<Either<Failure, List<ENTQuiz>>> call(QuizCreateQuizAIParams params) async {
    if(params.instruct.isEmpty) {
      return Left(InvalidInputFailure(message: 'Error input instruct empty'));
    }
    return quizRepository.getQuizzesAI(params.instruct, foreign: params.foreign);
  }
}