
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/flashcard/data/datasources/flashcardset_local_datasource.dart';
import 'package:smart_learn/features/flashcard/data/models/flashcardset_model.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcardset_repository.dart';

class REPFlashCardSetImpl extends REPFlashCardSet {
  final LDSFlashCardSet _localDataSource;
  REPFlashCardSetImpl(this._localDataSource);

  @override
  Future<Either<Failure, bool>> add(ENTFlashcardSet cardSet, {required FlashCardSetForeignParams foreignParams}) async {
    try {
      final result = await _localDataSource.add(MODFlashCardSet.fromEntity(cardSet), foreignParams: foreignParams);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(String id) async {
    try {
      final result = await _localDataSource.delete(id);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ENTFlashcardSet?>> get(String id) async {
    try {
      final result = await _localDataSource.get(id);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTFlashcardSet>>> getAll({required FlashCardSetForeignParams foreignParams}) async {
    try {
      final result = await _localDataSource.getAll(foreignParams: foreignParams);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(ENTFlashcardSet cardSet) async {
    try {
      final result = await _localDataSource.update(MODFlashCardSet.fromEntity(cardSet));
      return Right(result);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}