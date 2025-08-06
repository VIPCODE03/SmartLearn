
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcard_params.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcard_repository.dart';

class UCEFlashCardUpdate extends UseCase<ENTFlashCard, FlashCardUpdateParams> {
  final REPFlashCard flashCardRepository;
  UCEFlashCardUpdate({ required this.flashCardRepository });

  @override
  Future<Either<Failure, ENTFlashCard>> call(FlashCardUpdateParams params) async {
    final newFlashCard = ENTFlashCard(
      id: params.flashCard.id,
      front: params.front ?? params.flashCard.front,
      back: params.back ?? params.flashCard.back,
      flashCardSetId: params.flashCard.flashCardSetId,
    );

    final result = await flashCardRepository.update(newFlashCard);
    return result.fold(
            (fail) => Left(fail),
            (completed) => completed ? Right(newFlashCard) : Left(CacheFailure())
    );
  }
}