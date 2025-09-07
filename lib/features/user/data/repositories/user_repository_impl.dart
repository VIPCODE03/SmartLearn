import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/user/data/datasource/user_local_datasource.dart';
import 'package:smart_learn/features/user/data/models/user_model.dart';
import 'package:smart_learn/features/user/domain/entities/user_entity.dart';
import 'package:smart_learn/features/user/domain/repositories/user_repository.dart';

class REPUserImpl extends REPUser {
  final LDSUser _ldsUser;
  REPUserImpl(this._ldsUser);

  @override
  Future<Either<Failure, bool>> add(ENTUser user) async {
    try {
      final result = await _ldsUser.add(MODUser.fromEntity(user));
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(ENTUser user) async {
    try {
      final result = await _ldsUser.update(MODUser.fromEntity(user));
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ENTUser>> get() async {
    try {
      final result = await _ldsUser.get();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}