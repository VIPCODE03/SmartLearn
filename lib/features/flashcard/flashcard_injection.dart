import 'package:get_it/get_it.dart';
import 'package:smart_learn/features/flashcard/data/datasources/flashcard_ai_datasource.dart';
import 'package:smart_learn/features/flashcard/data/datasources/flashcard_local_datasource.dart';
import 'package:smart_learn/features/flashcard/data/datasources/flashcardset_local_datasource.dart';
import 'package:smart_learn/features/flashcard/data/datasources/flashcardset_native_datasource.dart';
import 'package:smart_learn/features/flashcard/data/repositories/flashcard_repository_impl.dart';
import 'package:smart_learn/features/flashcard/data/repositories/flashcardset_repository_impl.dart';
import 'package:smart_learn/features/flashcard/data/repositories/flashcardset_widget_repository_impl.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcard_repository.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcardset_repository.dart';
import 'package:smart_learn/features/flashcard/domain/repositories/flashcardset_widget_repository.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_add_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_delete_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_get_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_getwithai_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_multi_reset_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcard_usecase/flashcard_update_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcardset_usecase/flashcardset_add_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcardset_usecase/flashcardset_delete_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcardset_usecase/flashcardset_get_usecase.dart';
import 'package:smart_learn/features/flashcard/domain/usecases/flashcardset_usecase/flashcardset_update_usecase.dart';

Future<void> initFlashCardDI(GetIt getIt) async {
  // 1. UseCases
  getIt.registerLazySingleton(() => UCEFlashCardAdd(flashCardRepository: getIt()));
  getIt.registerLazySingleton(() => UCEFlashCardUpdate(flashCardRepository: getIt()));
  getIt.registerLazySingleton(() => UCEFlashCardMultiReset(getIt()));
  getIt.registerLazySingleton(() => UCEFlashCardDelete(flashCardRepository: getIt()));
  getIt.registerLazySingleton(() => UCEFlashCardGet(flashCardRepository: getIt()));

  getIt.registerLazySingleton(() => UCEFlashCardSetAdd(getIt()));
  getIt.registerLazySingleton(() => UCEFlashcardCreateAI(getIt()));
  getIt.registerLazySingleton(() => UCEFlashCardSetDelete(getIt()));
  getIt.registerLazySingleton(() => UCEFlashCardSetUpdate(getIt()));
  getIt.registerLazySingleton(() => UCEFlashCardSetGetList(getIt()));
  getIt.registerLazySingleton(() => UCEFlashCardSetGet(getIt()));


  // 2. Repository
  getIt.registerLazySingleton<REPFlashCard>(() => REPFlashCardImpl(getIt(), getIt()));
  getIt.registerLazySingleton<REPFlashCardSet>(() => REPFlashCardSetImpl(getIt()));
  getIt.registerLazySingleton<REPFlashCardSetWidget>(() => REPFlashCardSetWidgetImpl(getIt()));

  // 3. DataSource
  getIt.registerLazySingleton<LDSFlashCard>(() => LDSFlashCardImpl());
  getIt.registerLazySingleton<ADSFlashcard>(() => ADSFlashcardImpl());
  getIt.registerLazySingleton<LDSFlashCardSet>(() => LDSFlashCardSetImpl());
  getIt.registerLazySingleton<NDSFlashCardSet>(() => NDSFlashCardSetImpl());
}
