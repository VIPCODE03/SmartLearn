import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcardset_repository.dart';

class UCEFlashCardSetGetList extends UseCase<List<ENTFlashcardSet>, FlashCardSetGetListParams> {
  final REPFlashCardSet _repository;
  UCEFlashCardSetGetList(this._repository);

  @override
  Future<Either<Failure, List<ENTFlashcardSet>>> call(FlashCardSetGetListParams params) {
    if (params is FlashCardSetGetAllParams) {
      return _repository.getAll(foreignParams: params.foreignParams);
    }
    throw Exception('Invalid parameter type for UCEFlashCardSetGet');
  }
}

class UCEFlashCardSetGet extends UseCase<ENTFlashcardSet?, FlashCardSetGetParams> {
  final REPFlashCardSet _repository;
  UCEFlashCardSetGet(this._repository);

  @override
  Future<Either<Failure, ENTFlashcardSet?>> call(FlashCardSetGetParams params) {
    if (params is FlashCardSetGetByIdParams) {
      return _repository.get(params.id);
    }
    if(params is FlashCardSetGetByExtenalParams) {
      return _repository.getByExtenal(foreignParams: params.foreignParams);
    }
    throw Exception('Invalid parameter type for UCEFlashCardSetGet');
  }
}