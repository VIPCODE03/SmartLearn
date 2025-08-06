
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/subject/domain/entities/subject_entity.dart';

abstract class REPSubject {
  Future<Either<Failure, bool>> add(ENTSubject subject);
  Future<Either<Failure, bool>> update(ENTSubject subject);
  Future<Either<Failure, bool>> delete(String id);

  Future<Either<Failure, List<ENTSubject>>> getAllSubject();
}