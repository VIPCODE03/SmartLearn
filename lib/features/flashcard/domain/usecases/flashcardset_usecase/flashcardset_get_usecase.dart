import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcardset_repository.dart';

class UCEFlashCardSetGet extends UseCase<List<ENTFlashcardSet>, FlashCardSetGetParams> {
  final REPFlashCardSet _repository;
  UCEFlashCardSetGet(this._repository);

  @override
  Future<Either<Failure, List<ENTFlashcardSet>>> call(FlashCardSetGetParams params) {
    if (params is FlashCardSetGetAllParams) {
      return _repository.getAll(foreignParams: params.foreignParams);
    }
    // else if (params is FlashCardSetGetByIdParams) {
    //   return _repository.get(params.id);
    // }
    throw Exception('Invalid parameter type for UCEFlashCardSetGet');
  }
}