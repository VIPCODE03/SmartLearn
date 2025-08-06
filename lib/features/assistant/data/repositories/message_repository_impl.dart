
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/features/assistant/data/datasources/message_local_datasource.dart';
import 'package:smart_learn/features/assistant/data/models/content_model.dart';
import 'package:smart_learn/features/assistant/domain/entities/content_entity.dart';
import 'package:smart_learn/features/assistant/domain/parameters/mess_params.dart';
import 'package:smart_learn/features/assistant/domain/repositories/message_repository.dart';

class REPMessageImpl extends REPMessage {
  final LDSMessage localDataSource;
  REPMessageImpl(this.localDataSource);

  @override
  Future<Either<Failure, bool>> add(ENTMessage message, {required MessForeignParams foreign}) async {
    try {
      final result = await localDataSource.add(MODMessage.fromEntity(message), foreign: foreign);
      return Right(result);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPMessageImpl.add');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(String id) async {
    try {
      final result = await localDataSource.delete(id);
      return Right(result);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPMessageImpl.delete');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTMessage>>> getMessages({required MessForeignParams foreign}) async {
    try {
      final result = await localDataSource.getMessages(foreign: foreign);
      return Right(result);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPMessageImpl.getMessages');
      return Left(CacheFailure());
    }
  }
}