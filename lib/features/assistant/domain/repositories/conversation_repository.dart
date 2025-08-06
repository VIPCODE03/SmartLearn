
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/assistant/domain/entities/converstation_entity.dart';

abstract class REPConversation {

  Future<Either<Failure, bool>> add(ENTConversation conversation);

  Future<Either<Failure, bool>> update(ENTConversation conversation);

  Future<Either<Failure, bool>> delete(String id);

  Future<Either<Failure, List<ENTConversation>>> getAll();

  Future<Either<Failure, ENTConversation>> get(String id);

}