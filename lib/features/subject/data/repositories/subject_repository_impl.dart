import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/features/subject/data/datasources/subject_local_datasource.dart';
import 'package:smart_learn/features/subject/data/models/subject_model.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';
import 'package:smart_learn/features/subject/domain/repositories/subject_repository.dart';

class REPSubjectImpl extends REPSubject {
  final LDSSubject localDataSource;
  REPSubjectImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> add(ENTSubject subject) async {
    try {
      final result = await localDataSource.add(MODSubject.fromEntity(subject));
      return Right(result);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPSubjectImpl.add');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(ENTSubject subject) async {
    try {
      final result = await localDataSource.update(MODSubject.fromEntity(subject));
      logO(result);
      return Right(result);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPSubjectImpl.update');
      return Left(CacheFailure());
    }
  }


  @override
  Future<Either<Failure, bool>> delete(String id) async {
    try {
      final result = await localDataSource.delete(id);
      return Right(result);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPSubjectImpl.delete');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTSubject>>> getAllSubject() async {
    try {
      final models = await localDataSource.getAllSubject();
      return Right(models);
      } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPSubjectImpl.getAllSubject');
      return Left(CacheFailure());
    }
  }
}