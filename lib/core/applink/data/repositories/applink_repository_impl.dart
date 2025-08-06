
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/applink/data/datasources/applink_local_datasource.dart';
import 'package:smart_learn/core/applink/data/models/applink_model.dart';
import 'package:smart_learn/core/applink/domain/entities/applink_entity.dart';
import 'package:smart_learn/core/applink/domain/repositories/applink_repository.dart';
import 'package:smart_learn/core/error/failures.dart';

class REPAppLinkImpl extends REPAppLink {
  final LDSAppLink _localDataSource;
  REPAppLinkImpl(this._localDataSource);

  @override
  Future<Either<Failure, bool>> createLink(ENTAppLink link) async {
    try {
      final result = await _localDataSource.createLink(MODAppLink.fromEntity(link));
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteLink(ENTAppLink link) async {
    try {
      final result = await _localDataSource.deleteLink(MODAppLink.fromEntity(link));
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ENTAppLink?>> getLink(ENTAppLink link) async {
    try {
      final result = await _localDataSource.getLink(MODAppLink.fromEntity(link));
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> updateLink(ENTAppLink link) async {
    try {
      final result = await _localDataSource.updateLink(
          MODAppLink.fromEntity(link));
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}