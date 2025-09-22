import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcard_params.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcard_repository.dart';

class UCEFlashcardCreateAI extends UseCase<List<ENTFlashCard>, FlashCardGetWithAIParams> {
  final REPFlashCard flashcardRepository;
  UCEFlashcardCreateAI(this.flashcardRepository);

  @override
  Future<Either<Failure, List<ENTFlashCard>>> call(FlashCardGetWithAIParams params) async {
    if(params.instruct.isEmpty) {
      return Left(InvalidInputFailure(message: 'Error input instruct empty'));
    }
    return flashcardRepository.getWithAI(params.instruct, params.cardSetId);
  }
}