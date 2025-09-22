import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcardset_repository.dart';

class UCEFlashCardSetUpdate extends UseCase<ENTFlashcardSet, FlashCardSetUpdateParams> {
  final REPFlashCardSet _repository;
  UCEFlashCardSetUpdate(this._repository);

  @override
  Future<Either<Failure, ENTFlashcardSet>> call(FlashCardSetUpdateParams params) async {
    final updatedFlashCardSet = ENTFlashcardSet(
      id: params.flashcardSet.id,
      name: params.name ?? params.flashcardSet.name,
      isSelect: params.isSelect ?? params.flashcardSet.isSelect,
    );
    final result = await _repository.update(updatedFlashCardSet);
    return result.fold(
            (fail) => Left(fail),
            (completed) => Right(updatedFlashCardSet)
    );
  }
}