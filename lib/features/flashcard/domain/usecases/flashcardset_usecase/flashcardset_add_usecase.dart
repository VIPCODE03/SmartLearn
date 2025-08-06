import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcardset_repository.dart';
import 'package:smart_learn/utils/generate_id_util.dart';

class UCEFlashCardSetAdd extends UseCase<ENTFlashcardSet, FlashCardSetAddParams> {
  final REPFlashCardSet _repository;
  UCEFlashCardSetAdd(this._repository);

  @override
  Future<Either<Failure, ENTFlashcardSet>> call(FlashCardSetAddParams params) async {
    final newFlashCardSet = ENTFlashcardSet(
      id: UTIGenerateID.random(),
      name: params.name,
      isSelect: false,
    );
    final result = await _repository.add(newFlashCardSet, foreignParams: params.foreignParams);
    return result.fold(
        (fail) => Left(fail),
        (completed) => Right(newFlashCardSet)
    );
  }
}