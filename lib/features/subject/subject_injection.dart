import 'package:get_it/get_it.dart';
import 'package:smart_learn/features/subject/data/datasources/subject_local_datasource.dart';
import 'package:smart_learn/features/subject/data/repositories/subject_repository_impl.dart';
import 'package:smart_learn/features/subject/domain/repositories/subject_repository.dart';
import 'package:smart_learn/features/subject/domain/usecases/subject_add_usecase.dart';
import 'package:smart_learn/features/subject/domain/usecases/subject_delete_usecase.dart';
import 'package:smart_learn/features/subject/domain/usecases/subject_get_usecase.dart';
import 'package:smart_learn/features/subject/domain/usecases/subject_update_usecase.dart';

Future<void> initSubjectDI(GetIt getIt) async {
  // 1. UseCases
  getIt.registerLazySingleton(() => UCESubjectAdd(repository: getIt()));
  getIt.registerLazySingleton(() => UCESubjectUpdate(repository: getIt()));
  getIt.registerLazySingleton(() => UCESubjectDelete(repository: getIt()));
  getIt.registerLazySingleton(() => UCESubjectGet(repository: getIt()));

  // 2. Repository
  getIt.registerLazySingleton<REPSubject>(() => REPSubjectImpl(localDataSource: getIt()));

  // 3. DataSource
  getIt.registerLazySingleton<LDSSubject>(() => LDSSubjectImpl());
}
