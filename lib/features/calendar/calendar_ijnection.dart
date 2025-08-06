import 'package:get_it/get_it.dart';
import 'package:smart_learn/features/calendar/data/datasources/calendar_local_data_source.dart';
import 'package:smart_learn/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:smart_learn/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:smart_learn/features/calendar/domain/usecases/calendar_get_usecase.dart';

import 'domain/usecases/calendar_add_update_usecase.dart';
import 'domain/usecases/calendar_check_duplicate_usecase.dart';

Future<void> initCalendarDI(GetIt getIt) async {

  // 1. UseCases
  getIt.registerLazySingleton(() => UCECalendarGet(getIt()));
  getIt.registerLazySingleton(() => UCECalendarCheckDuplicate(getIt()));
  getIt.registerLazySingleton(() => UCECalendarAddOrUpdate(getIt()));

  // 2. Repository
  getIt.registerLazySingleton<REPCalendar>(() => REPCalendarImpl(localDataSource: getIt()));

  // 3. DataSource
  getIt.registerLazySingleton<LDSCalendar>(() => LDSCalendarImpl());
}
