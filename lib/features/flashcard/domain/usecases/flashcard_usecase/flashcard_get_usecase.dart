
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcard_params.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcard_repository.dart';

class UCEFlashCardGet extends UseCase<List<ENTFlashCard>, FlashCardGetParams> {
  final REPFlashCard flashCardRepository;
  UCEFlashCardGet({ required this.flashCardRepository });

  @override
  Future<Either<Failure, List<ENTFlashCard>>> call(FlashCardGetParams params) {
    switch(params) {
      case FlashCardGetAllParams():
        return flashCardRepository.getByCardSetId(params.cardSetId);
      default:
        throw UnimplementedError();
    }
  }
}