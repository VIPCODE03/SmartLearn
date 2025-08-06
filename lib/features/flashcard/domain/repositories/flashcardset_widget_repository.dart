
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';

abstract class REPFlashCardSetWidget {
  Future<Either<Failure, bool>> update(ENTFlashcardSet cardSet);
  Future<Either<Failure, bool>> delete(ENTFlashcardSet cardSet);
}