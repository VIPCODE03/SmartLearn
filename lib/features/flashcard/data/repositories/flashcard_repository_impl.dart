
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/error/log.dart';
import 'package:smart_learn/features/flashcard/data/datasources/flashcard_ai_datasource.dart';
import 'package:smart_learn/features/flashcard/data/datasources/flashcard_local_datasource.dart';
import 'package:smart_learn/features/flashcard/data/models/flashcard_model.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcard_repository.dart';

class REPFlashCardImpl extends REPFlashCard {
  final LDSFlashCard _ldsFlashCard;
  final ADSFlashcard _adsFlashcard;
  REPFlashCardImpl(this._ldsFlashCard, this._adsFlashcard);

  @override
  Future<Either<Failure, bool>> add(ENTFlashCard flashCard) async {
    try {
      final result = await _ldsFlashCard.add(MODFlashCard.fromEntity(flashCard));
      return Right(result);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPFlashCardImpl.add');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(String id) async {
    try {
      final result = await _ldsFlashCard.delete(id);
      return Right(result);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPFlashCardImpl.delete');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTFlashCard>>> getByCardSetId(String cardSetId) async {
    try {
      final result = await _ldsFlashCard.getByCardSetId(cardSetId);
      return Right(result);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPFlashCardImpl.getByCardSetId');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> update(ENTFlashCard flashCard) async {
    try {
      final result = await _ldsFlashCard.update(MODFlashCard.fromEntity(flashCard));
      return Right(result);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPFlashCardImpl.update');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> multiReset(List<String> ids) async {
    try {
      final result = await _ldsFlashCard.multiReset(ids);
      return Right(result);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPFlashCardImpl.multiReset');
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ENTFlashCard>>> getWithAI(String instruct, String cardSetId) async {
    try {
      final result = await _adsFlashcard.getFlashCard(instruct, cardSetId);
      return Right(result);
    } catch (e, s) {
      logError(e, stackTrace: s, context: 'REPFlashCardImpl.getWithAI');
      return Left(CacheFailure());
    }
  }
}