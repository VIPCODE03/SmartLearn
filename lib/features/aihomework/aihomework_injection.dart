import 'package:get_it/get_it.dart';
import 'package:smart_learn/features/aihomework/data/datasources/aihomework_history_local_datasource.dart';
import 'package:smart_learn/features/aihomework/data/repositories/aihomework_history_repository_impl.dart';
import 'package:smart_learn/features/aihomework/domain/repositories/aihomework_repository.dart';
import 'package:smart_learn/features/aihomework/domain/usecases/aihomework_history_add_usecase.dart';
import 'package:smart_learn/features/aihomework/domain/usecases/aihomework_history_delete_usecase.dart';
import 'package:smart_learn/features/aihomework/domain/usecases/aihomework_history_get_usecase.dart';
import 'package:smart_learn/features/aihomework/domain/usecases/aihomework_history_update_usecase.dart';

Future<void> initAIHomeWorkDI(GetIt getIt) async {

  // 1. UseCases
  getIt.registerLazySingleton(() => UCEAIHomeWorkHistoryAdd(getIt()));
  getIt.registerLazySingleton(() => UCEAIHomeWorkHistoryDelete(getIt()));
  getIt.registerLazySingleton(() => UCEAIHomeWorkHistoryGet(getIt()));
  getIt.registerLazySingleton(() => UCEAIHomeWorkHistoryUpdate(getIt()));

  // 2. Repository
  getIt.registerLazySingleton<REPAIHomeWorkHistory>(() => REPAIHomeWorkHistoryImpl(getIt()));

  // 3. DataSource
  getIt.registerLazySingleton<LDSAIHomeWorkHistory>(() => LDSAIHomeWorkHistoryImpl());
}
