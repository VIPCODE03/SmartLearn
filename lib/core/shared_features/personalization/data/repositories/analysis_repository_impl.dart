
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/core/shared_features/personalization/data/datasource/data_analysis_local_datasource.dart';
import 'package:smart_learn/core/shared_features/personalization/data/models/data_analysis_model.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/entities/data_analysis_entity.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/repositories/analysis_repository.dart';

class REPDataAnalysisImpl extends REPAnalysis {
  final LDSDataAnalysis _localDataSource;
  REPDataAnalysisImpl(this._localDataSource);

  @override
  Future<Either<Failure, bool>> add(ENTAnalysis entity) async {
    try {
      final result = await _localDataSource.add(MODDataAnalysis.fromEntity(entity));
      return Right(result);
    } catch (e, s) {
      logError(e.toString(), stackTrace: s, context: 'REPDataAnalysisImpl.add');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(ENTAnalysis entity) async {
    try {
      final result = await _localDataSource.update(MODDataAnalysis.fromEntity(entity));
      return Right(result);
    } catch (e, s) {
      logError(e.toString(), stackTrace: s, context: 'REPDataAnalysisImpl.update');
      return Left(CacheFailure());
    }
  }


  @override
  Future<Either<Failure, bool>> delete(String id) async {
    try {
      final result = await _localDataSource.delete(id);
      return Right(result);
    } catch (e, s) {
      logError(e.toString(), stackTrace: s, context: 'REPDataAnalysisImpl.delete');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAll() async {
    try {
      final result = await _localDataSource.deleteAll();
      return Right(result);
    } catch (e, s) {
      logError(e.toString(), stackTrace: s, context: 'REPDataAnalysisImpl.deleteAll');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteByOwnerId(String ownerId) async {
    try {
      final result = await _localDataSource.deleteByOwnerId(ownerId);
      return Right(result);
    } catch (e, s) {
      logError(e.toString(), stackTrace: s, context: 'REPDataAnalysisImpl.deleteByOwnerId');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteByTag(String tag) async {
    try {
      final result = await _localDataSource.deleteByTag(tag);
      return Right(result);
    } catch (e, s) {
      logError(e.toString(), stackTrace: s, context: 'REPDataAnalysisImpl.deleteByTag');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTAnalysis>>> getAll() async {
    try {
      final result = await _localDataSource.getAll();
      return Right(result);
    } catch (e, s) {
      logError(e.toString(), stackTrace: s, context: 'REPDataAnalysisImpl.getAll');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ENTAnalysis?>> getById(String id) async {
    try {
      final result = await _localDataSource.getById(id);
      return Right(result);
    } catch (e, s) {
      logError(e.toString(), stackTrace: s, context: 'REPDataAnalysisImpl.getById');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ENTAnalysis?>> getByOwnerId(String ownerId) async {
    try {
      final result = await _localDataSource.getByOwnerId(ownerId);
      return Right(result);
    } catch (e, s) {
      logError(e.toString(), stackTrace: s, context: 'REPDataAnalysisImpl.getByOwnerId');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTAnalysis>>> getByTag(String tag) async {
    try {
      final result = await _localDataSource.getByTag(tag);
      return Right(result);
    } catch (e, s) {
      logError(e.toString(), stackTrace: s, context: 'REPDataAnalysisImpl.getByTag');
      return Left(CacheFailure());
    }
  }

}