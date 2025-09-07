import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcard_params.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcard_repository.dart';

class UCEFlashCardMultiReset extends UseCase<List<ENTFlashCard>, FlashCardMultiResetParams> {
  final REPFlashCard _respository;
  UCEFlashCardMultiReset(this._respository);

  @override
  Future<Either<Failure, List<ENTFlashCard>>> call(FlashCardMultiResetParams params) async {
    List<String> ids = [];
    List<ENTFlashCard> cardsUpdated = [];
    for(var card in params.cards) {
      ids.add(card.id);
      cardsUpdated.add(
        ENTFlashCard(id: card.id, flashCardSetId: card.flashCardSetId, front: card.front, back: card.back)
      );
    }
    final result = await _respository.multiReset(ids);
    return result.fold(
            (l) => Left(CacheFailure()),
            (sucsess) => sucsess ? Right(cardsUpdated) : Left(CacheFailure())
    );
  }
}