
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/aihomework/data/datasources/aihomework_history_local_datasource.dart';
import 'package:smart_learn/features/aihomework/data/models/aihomework_model.dart';
import 'package:smart_learn/features/aihomework/domain/entities/aihomework_history_entity.dart';
import 'package:smart_learn/features/aihomework/domain/repositories/aihomework_repository.dart';

class REPAIHomeWorkHistoryImpl extends REPAIHomeWorkHistory {
  final LDSAIHomeWorkHistory _localDataSource;
  REPAIHomeWorkHistoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, bool>> add(ENTAIHomeWorkHistory history) async {
    try {
      final result = await _localDataSource.add(MODAIHomeWorkHistory.fromEntity(history));
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(ENTAIHomeWorkHistory history) async {
    try {
      final result = await _localDataSource.update(MODAIHomeWorkHistory.fromEntity(history));
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(String id) async {
    try {
      final result = await _localDataSource.delete(id);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTAIHomeWorkHistory>>> getAll() async {
    try {
      final result = await _localDataSource.getAll();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}