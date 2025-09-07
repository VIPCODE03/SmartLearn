
import 'package:smart_learn/features/flashcard/domain/entities/flashcardset_entity.dart';

class FlashCardSetForeignParams {
  final String? fileId;
  FlashCardSetForeignParams.none() : fileId = null;
  FlashCardSetForeignParams.byFileID({this.fileId});
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
abstract class FlashCardSetGetListParams {}

class FlashCardSetGetAllParams extends FlashCardSetGetListParams {
  final FlashCardSetForeignParams foreignParams;
  FlashCardSetGetAllParams(this.foreignParams);
}

abstract class FlashCardSetGetParams {}

class FlashCardSetGetByIdParams extends FlashCardSetGetParams {
  final String id;
  FlashCardSetGetByIdParams(this.id);
}

class FlashCardSetGetByExtenalParams extends FlashCardSetGetParams {
  final FlashCardSetForeignParams foreignParams;
  FlashCardSetGetByExtenalParams(this.foreignParams);
}
