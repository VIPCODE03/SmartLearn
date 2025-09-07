import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/shared_features/personalization/domain/entities/data_analysis_entity.dart';

abstract class REPAnalysis {
  Future<Either<Failure, bool>> add(ENTAnalysis entity);
  Future<Either<Failure, bool>> update(ENTAnalysis entity);
  Future<Either<Failure, bool>> delete(String id);
  Future<Either<Failure, bool>> deleteAll();
  Future<Either<Failure, bool>> deleteByTag(String tag);
  Future<Either<Failure, bool>> deleteByOwnerId(String ownerId);

  Future<Either<Failure, List<ENTAnalysis>>> getAll();
  Future<Either<Failure, ENTAnalysis?>> getById(String id);
  Future<Either<Failure, List<ENTAnalysis>>> getByTag(String tag);
  Future<Either<Failure, ENTAnalysis?>> getByOwnerId(String ownerId);
}