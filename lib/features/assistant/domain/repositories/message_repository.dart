
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/assistant/domain/entities/content_entity.dart';
import 'package:smart_learn/features/assistant/domain/parameters/mess_params.dart';

abstract class REPMessage {
  Future<Either<Failure, bool>> add(ENTMessage message, {required MessForeignParams foreign});
  Future<Either<Failure, bool>> delete(String id);
  Future<Either<Failure, List<ENTMessage>>> getMessages({required MessForeignParams foreign});
}