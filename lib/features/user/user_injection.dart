import 'package:get_it/get_it.dart';
import 'package:smart_learn/features/user/data/datasource/user_local_datasource.dart';
import 'package:smart_learn/features/user/data/repositories/user_repository_impl.dart';
import 'package:smart_learn/features/user/domain/repositories/user_repository.dart';
import 'package:smart_learn/features/user/domain/usecases/user_add_usecase.dart';
import 'package:smart_learn/features/user/domain/usecases/user_get_usecase.dart';
import 'package:smart_learn/features/user/domain/usecases/user_update_usecase.dart';

Future<void> initUserDI(GetIt getIt) async {
  // 1. UseCases
  getIt.registerLazySingleton(() => UCEUserAdd(getIt()));
  getIt.registerLazySingleton(() => UCEUserUpdate(getIt()));
  getIt.registerLazySingleton(() => UCEUserGet(getIt()));

  // 2. Repository
  getIt.registerLazySingleton<REPUser>(() => REPUserImpl(getIt()));

  // 3. DataSource
  getIt.registerLazySingleton<LDSUser>(() => LDSUserImpl());
}
