import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/features/flashcard/data/datasources/flashcardset_native_datasource.dart';
import 'package:smart_learn/features/flashcard/data/models/flashcardset_model.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcardset_widget_repository.dart';

class REPFlashCardSetWidgetImpl extends REPFlashCardSetWidget {
  final NDSFlashCardSet _nativeDataSource;
  REPFlashCardSetWidgetImpl(this._nativeDataSource);

  @override
  Future<Either<Failure, bool>> update(ENTFlashcardSet cardSet) async {
    try {
      await _nativeDataSource.update(MODFlashCardSet.fromEntity(cardSet));
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(ENTFlashcardSet cardSet) async {
    try {
      await _nativeDataSource.remove(MODFlashCardSet.fromEntity(cardSet));
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}