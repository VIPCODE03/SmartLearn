import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_params.dart';

abstract class REPQuiz {
  Future<Either<Failure, bool>> add(ENTQuiz quiz, {required ForeignKeyParams foreign});
  Future<Either<Failure, bool>> update(ENTQuiz quiz);
  Future<Either<Failure, bool>> delete(String id);

  Future<Either<Failure, ENTQuiz?>> getById(String id);
  Future<Either<Failure, List<ENTQuiz>>> getAll({required ForeignKeyParams foreign});

  Future<Either<Failure, List<ENTQuiz>>> getQuizzesAI(String intruct, {required ForeignKeyParams foreign});
}