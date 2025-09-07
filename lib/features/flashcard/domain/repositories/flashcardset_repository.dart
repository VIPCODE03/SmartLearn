
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';

abstract class REPFlashCardSet {
  Future<Either<Failure, bool>> add(ENTFlashcardSet cardSet, {required FlashCardSetForeignParams foreignParams});
  Future<Either<Failure, bool>> update(ENTFlashcardSet cardSet);
  Future<Either<Failure, bool>> delete(String id);

  Future<Either<Failure, List<ENTFlashcardSet>>> getAll({required FlashCardSetForeignParams foreignParams});
  Future<Either<Failure, ENTFlashcardSet?>> get(String id);
  Future<Either<Failure, ENTFlashcardSet?>> getByExtenal({required FlashCardSetForeignParams foreignParams});

}