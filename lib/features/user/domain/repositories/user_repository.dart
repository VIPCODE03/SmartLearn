import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/user/domain/entities/user_entity.dart';

abstract class REPUser {
  Future<Either<Failure, bool>> add(ENTUser user);
  Future<Either<Failure, bool>> update(ENTUser user);
  Future<Either<Failure, ENTUser>> get();
}