
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/aihomework/domain/entities/aihomework_history_entity.dart';

abstract class REPAIHomeWorkHistory {
  Future<Either<Failure, bool>> add(ENTAIHomeWorkHistory history);
  Future<Either<Failure, bool>> update(ENTAIHomeWorkHistory history);
  Future<Either<Failure, bool>> delete(String id);
  Future<Either<Failure, List<ENTAIHomeWorkHistory>>> getAll();
}