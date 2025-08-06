import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcardsetpramas/foreign_params.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcardset_repository.dart';

class UCEFlashCardSetDelete extends UseCase<bool, FlashCardSetDeleteParams> {
  final REPFlashCardSet _repository;
  UCEFlashCardSetDelete(this._repository);

  @override
  Future<Either<Failure, bool>> call(FlashCardSetDeleteParams params) {
    return _repository.delete(params.id);
  }
}