
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/applink/domain/entities/applink_entity.dart';
import 'package:smart_learn/core/error/failures.dart';

abstract class REPAppLink {
  Future<Either<Failure, bool>> createLink(ENTAppLink link);
  Future<Either<Failure, bool>> deleteLink(ENTAppLink link);
  Future<Either<Failure, bool>> updateLink(ENTAppLink link);
  Future<Either<Failure, ENTAppLink?>> getLink(ENTAppLink link);
}