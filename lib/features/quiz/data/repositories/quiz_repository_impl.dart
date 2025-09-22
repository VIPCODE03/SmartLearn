import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/features/quiz/data/datasources/quiz_ai_source.dart';
import 'package:smart_learn/features/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:smart_learn/features/quiz/data/models/a_quiz_model.dart';
import 'package:smart_learn/features/quiz/domain/entities/a_quiz_entity.dart';
import 'package:smart_learn/features/quiz/domain/parameters/quiz_params.dart';
import 'package:smart_learn/features/quiz/domain/repositories/quiz_repository.dart';

class REPQuizSetImpl extends REPQuiz {
  final LDSQuiz _localDataSource;
  final ADSQuiz _aiDataSource;

  REPQuizSetImpl(this._localDataSource, this._aiDataSource);

  @override
  Future<Either<Failure, bool>> add(ENTQuiz quiz, {required ForeignKeyParams foreign}) async {
    try {
      final quizSet = await _localDataSource.add(MODQuiz.fromEntity(quiz), foreign: foreign);
      if(quizSet) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPQuizSetImpl.add');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(String id) async {
    try {
      final quizSet = await _localDataSource.delete(id);
      if(quizSet) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPQuizSetImpl.delete');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTQuiz>>> getAll({required ForeignKeyParams foreign}) async {
    try {
      final quizSets = await _localDataSource.getAll(foreign: foreign);
      return Right(quizSets);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPQuizSetImpl.getAll');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ENTQuiz?>> getById(String id) async {
    try {
      final quizSet = await _localDataSource.getById(id);
      return Right(quizSet);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPQuizSetImpl.getById');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(ENTQuiz quiz) async {
    try {
      final result = await _localDataSource.update(MODQuiz.fromEntity(quiz));
      if(result) {
        return const Right(true);
      } else {
        return const Right(false);
      }
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPQuizSetImpl.update');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTQuiz>>> getQuizzesAI(String instruct, {required ForeignKeyParams foreign}) async {
    try {
      final quizzes = await _aiDataSource.getQuizzesAI(instruct, foreign: foreign);
      return Right(quizzes);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPQuizSetImpl.getQuizzesAI');
      return Left(NetworkFailure());
    }
  }
}