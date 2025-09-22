
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';

abstract class REPFlashCard {
  Future<Either<Failure, bool>> add(ENTFlashCard flashCard);
  Future<Either<Failure, bool>> update(ENTFlashCard flashCard);
  Future<Either<Failure, bool>> multiReset(List<String> ids);
  Future<Either<Failure, bool>> delete(String id);

  Future<Either<Failure, List<ENTFlashCard>>> getByCardSetId(String cardSetId);
  Future<Either<Failure, List<ENTFlashCard>>> getWithAI(String instruct, String cardSetId);
}