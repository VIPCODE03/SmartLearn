
import 'package:dartz/dartz.dart';
import 'package:smart_learn/core/error/failures.dart';
import 'package:smart_learn/core/usecase.dart';
import 'package:smart_learn/features/flashcard/domain/parameters/flashcard_params.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcard_repository.dart';

class UCEFlashCardDelete extends UseCase<bool, FlashCardDeleteParams> {
  final REPFlashCard flashCardRepository;
  UCEFlashCardDelete({ required this.flashCardRepository });

  @override
  Future<Either<Failure, bool>> call(FlashCardDeleteParams params) {
    return flashCardRepository.delete(params.id);
  }
}