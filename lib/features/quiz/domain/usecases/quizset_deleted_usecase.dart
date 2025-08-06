
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_delete_params.dart';
import 'package:smart_learn/features/quiz/domain/repositories/quiz_repository.dart';

class UCEQuizSetDeleted extends UseCase<bool, QuizSetDeleteParams> {
  final REPQuiz repository;
  UCEQuizSetDeleted(this.repository);

  @override
  Future<Either<Failure, bool>> call(QuizSetDeleteParams params) {
    return repository.delete(params.id);
  }
}