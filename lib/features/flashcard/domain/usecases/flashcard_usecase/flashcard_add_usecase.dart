import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase/usecase.dart';
import 'package:smart_learn/features/flashcard/domain/entities/flashcard_entity.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcard_params.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcard_repository.dart';
import 'package:smart_learn/utils/generate_id_util.dart';


class UCEFlashCardAdd extends UseCase<ENTFlashCard, FlashCardAddParams> {
  final REPFlashCard flashCardRepository;
  UCEFlashCardAdd({ required this.flashCardRepository });

  @override
  Future<Either<Failure, ENTFlashCard>> call(FlashCardAddParams params) async {
    final newFlashCard = ENTFlashCard(
      id: UTIGenerateID.random(),
      front: params.front,
      back: params.back,
      flashCardSetId: params.cardSetId,
    );
    final result = await flashCardRepository.add(newFlashCard);
    return result.fold(
            (fail) => Left(fail),
            (completed) => completed ? Right(newFlashCard) : Left(CacheFailure())
    );
  }
}