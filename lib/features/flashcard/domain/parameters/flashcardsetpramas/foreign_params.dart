
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';

class FlashCardSetForeignParams {
  final String? fileId;
  FlashCardSetForeignParams({this.fileId});
}

//- Add ------
class FlashCardSetAddParams {
  final String name;
  final FlashCardSetForeignParams foreignParams;
  FlashCardSetAddParams(this.foreignParams, {required this.name});
}

//- Update  -----
class FlashCardSetUpdateParams {
  final ENTFlashcardSet flashcardSet;
  final String? name;
  final bool? isSelect;

  FlashCardSetUpdateParams(this.flashcardSet, {this.name, this.isSelect});
}

//- Delete  ----
class FlashCardSetDeleteParams {
  final String id;
  FlashCardSetDeleteParams(this.id);
}

//- get -----
abstract class FlashCardSetGetParams {}

class FlashCardSetGetAllParams extends FlashCardSetGetParams {
  final FlashCardSetForeignParams foreignParams;
  FlashCardSetGetAllParams(this.foreignParams);
}

class FlashCardSetGetByIdParams extends FlashCardSetGetParams {
  final String id;
  FlashCardSetGetByIdParams(this.id);
}
