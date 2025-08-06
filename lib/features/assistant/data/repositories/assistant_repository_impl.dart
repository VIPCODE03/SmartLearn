
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/features/assistant/data/datasources/conversation_local_datasource.dart';
import 'package:smart_learn/features/assistant/data/models/conversation_model.dart';
import 'package:smart_learn/features/assistant/domain/entities/converstation_entity.dart';
import 'package:smart_learn/features/assistant/domain/repositories/conversation_repository.dart';

class REPConversationImpl extends REPConversation {
  final LDSConversation _localDataSource;
  REPConversationImpl(this._localDataSource);

  @override
  Future<Either<Failure, bool>> add(ENTConversation conversation) async {
    try {
      final result = await _localDataSource.add(MODConversation.fromEntity(conversation));
      return Right(result);
    }
    catch (e, s) {
      logError(e, stackTrace: s, context: 'REPConversationImpl.add');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(ENTConversation conversation) async {
    try {
      final result = await _localDataSource.update(MODConversation.fromEntity(conversation));
      return Right(result);
    }
    catch (e, s) {
      logError(e, stackTrace: s, context: 'REPConversationImpl.update');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(String id) async {
    try {
      final result = await _localDataSource.delete(id);
      return Right(result);
    }
    catch (e, s) {
      logError(e, stackTrace: s, context: 'REPConversationImpl.delete');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ENTConversation>> get(String id) async {
    try {
      final result = await _localDataSource.get(id);
      return Right(result);
    }
    catch (e, s) {
      logError(e, stackTrace: s, context: 'REPConversationImpl.get');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTConversation>>> getAll() async {
    try {
      final result = await _localDataSource.getAll();
      return Right(result);
    }
    catch (e, s) {
      logError(e, stackTrace: s, context: 'REPConversationImpl.getAll');
      return Left(CacheFailure());
    }
  }
}