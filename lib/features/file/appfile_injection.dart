import 'package:get_it/get_it.dart';
import 'package:smart_learn/features/file/data/datasources/appfile_datasource_local.dart';
import 'package:smart_learn/features/file/data/repositories/appfile_repository_impl.dart';
import 'package:smart_learn/features/file/domain/repositories/appfile_repository.dart';
import 'package:smart_learn/features/file/domain/usecases/appfile_checknameduplicate_usecase.dart';
import 'package:smart_learn/features/file/domain/usecases/appfile_create_usecase.dart';
import 'package:smart_learn/features/file/domain/usecases/appfile_delete_usecase.dart';
import 'package:smart_learn/features/file/domain/usecases/appfile_load_usecase.dart';
import 'package:smart_learn/features/file/domain/usecases/appfile_update_usecase.dart';

Future<void> initFileDI(GetIt getIt) async {
  // 1. UseCases
  getIt.registerLazySingleton(() => UCEAppFileCreate(getIt()));
  getIt.registerLazySingleton(() => UCEAppFileUpdate(getIt()));
  getIt.registerLazySingleton(() => UCEAppFileDelete(getIt()));
  getIt.registerLazySingleton(() => UCEAppFileCheckNameDuplicate(getIt()));
  getIt.registerLazySingleton(() => UCEAppFileLoad(getIt()));

  // 2. Repository
  getIt.registerLazySingleton<REPAppFile>(() => REPAppFileImpl(getIt()));

  // 3. DataSource
  getIt.registerLazySingleton<LDSAppFile>(() => LDSAppFileImpl());
}
