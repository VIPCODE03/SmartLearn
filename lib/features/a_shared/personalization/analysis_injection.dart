import 'package:get_it/get_it.dart';
import 'package:smart_learn/features/a_shared/personalization/data/datasource/data_analysis_local_datasource.dart';
import 'package:smart_learn/features/a_shared/personalization/data/repositories/analysis_repository_impl.dart';
import 'package:smart_learn/features/a_shared/personalization/domain/repositories/analysis_repository.dart';
import 'package:smart_learn/features/a_shared/personalization/domain/usecases/add_usecase.dart';
import 'package:smart_learn/features/a_shared/personalization/domain/usecases/delete_usecase.dart';
import 'package:smart_learn/features/a_shared/personalization/domain/usecases/get_usecase.dart';
import 'package:smart_learn/features/a_shared/personalization/domain/usecases/update_usecase.dart';

Future<void> initAnalysisDI(GetIt getIt) async {

  // 1. UseCases
  getIt.registerLazySingleton(() => UCEAnalysisAdd(getIt()));
  getIt.registerLazySingleton(() => UCEAnalysisUpdate(getIt()));
  getIt.registerLazySingleton(() => UCEAnalysisDelete(getIt()));
  getIt.registerLazySingleton(() => UCEDataAnalysisGetData(getIt()));
  getIt.registerLazySingleton(() => UCEDataAnalysisGetList(getIt()));

  // 2. Repository
  getIt.registerLazySingleton<REPAnalysis>(() => REPDataAnalysisImpl(getIt()));

  // 3. DataSource
  getIt.registerLazySingleton<LDSDataAnalysis>(() => LDSDataAnalysisImpl());
}
