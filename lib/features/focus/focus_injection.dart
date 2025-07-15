import 'package:get_it/get_it.dart';
import 'package:smart_learn/features/focus/data/datasources/focus_local_data_source.dart';
import 'package:smart_learn/features/focus/data/repositories/focus_repository_impl.dart';
import 'package:smart_learn/features/focus/domain/usecases/get_focus.dart';
import 'package:smart_learn/features/focus/domain/usecases/update_focus.dart';
import 'package:smart_learn/features/focus/domain/repositories/focus_repository.dart';
import 'package:smart_learn/features/focus/presentation/state_manages/focus_performer/focus_performer.dart';

import 'domain/usecases/a_add_time_focus.dart';

Future<void> initFocusDI(GetIt getIt) async {
  getIt.registerSingleton<FocusPerformer>(FocusPerformer());

  // 1. UseCases
  getIt.registerLazySingleton(() => UCEGetFocus(focusRepository: getIt()));
  getIt.registerLazySingleton(() => UCEUpdateFocus(focusRepository: getIt()));
  getIt.registerLazySingleton(() => UCEAddTimeFocus(focusRepository: getIt()));

  // 2. Repository
  getIt.registerLazySingleton<REPFocus>(() => REPFocusImpl(focusLocalDataSource: getIt()));

  // 3. DataSource
  getIt.registerLazySingleton<LDSFocus>(() => LDSFocusImpl(sharedPreferences: getIt()));
}
