import 'package:get_it/get_it.dart';
import 'package:smart_learn/features/quiz/data/datasources/quiz_ai_source.dart';
import 'package:smart_learn/features/quiz/data/datasources/quiz_local_datasource.dart';
import 'package:smart_learn/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:smart_learn/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:smart_learn/features/quiz/domain/usecases/quizset_add_usecase.dart';
import 'package:smart_learn/features/quiz/domain/usecases/quizset_create_quiz_ai_usecase.dart';
import 'package:smart_learn/features/quiz/domain/usecases/quizset_deleted_usecase.dart';
import 'package:smart_learn/features/quiz/domain/usecases/quizset_get_usecase.dart';
import 'package:smart_learn/features/quiz/domain/usecases/quizset_update_usecase.dart';

Future<void> initQuizDI(GetIt getIt) async {
  // 1. UseCases
  getIt.registerLazySingleton(() => UCEQuizAdd(getIt()));
  getIt.registerLazySingleton(() => UCEQuizSetUpdate(getIt()));
  getIt.registerLazySingleton(() => UCEQuizSetDeleted(getIt()));
  getIt.registerLazySingleton(() => UCEQuizSetGet(getIt()));
  getIt.registerLazySingleton(() => UCEQuizSetCreateQuizAI(getIt()));

  // 2. Repository
  getIt.registerLazySingleton<REPQuiz>(() => REPQuizSetImpl(getIt(), getIt()));

  // 3. DataSource
  getIt.registerLazySingleton<LDSQuiz>(() => LDSQuizImpl());
  getIt.registerLazySingleton<ADSQuiz>(() => ADSQuizImpl());
}
