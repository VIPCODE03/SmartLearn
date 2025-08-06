import 'package:get_it/get_it.dart';
import 'package:smart_learn/features/assistant/data/datasources/conversation_local_datasource.dart';
import 'package:smart_learn/features/assistant/data/datasources/message_local_datasource.dart';
import 'package:smart_learn/features/assistant/data/repositories/assistant_repository_impl.dart';
import 'package:smart_learn/features/assistant/data/repositories/message_repository_impl.dart';
import 'package:smart_learn/features/assistant/domain/repositories/conversation_repository.dart';
import 'package:smart_learn/features/assistant/domain/repositories/message_repository.dart';
import 'package:smart_learn/features/assistant/domain/usecases/conversation_usecases/conversation_add_usecase.dart';
import 'package:smart_learn/features/assistant/domain/usecases/conversation_usecases/conversation_update_usecase.dart';
import 'package:smart_learn/features/assistant/domain/usecases/conversation_usecases/delete_conversation_usecase.dart';
import 'package:smart_learn/features/assistant/domain/usecases/conversation_usecases/get_conversation_usecase.dart';
import 'package:smart_learn/features/assistant/domain/usecases/message_usecase/mess_add_usecase.dart';
import 'package:smart_learn/features/assistant/domain/usecases/message_usecase/mess_get_usecase.dart';

Future<void> initAssistantDI(GetIt getIt) async {

  // 1. UseCases
  getIt.registerLazySingleton(() => UCEConversationAdd(getIt()));
  getIt.registerLazySingleton(() => UCEConversationUpdate(getIt()));
  getIt.registerLazySingleton(() => UCEConversationDelete(getIt()));
  getIt.registerLazySingleton(() => UCEConversationGet(getIt()));

  getIt.registerLazySingleton(() => UCEMessAdd(getIt()));
  getIt.registerLazySingleton(() => UCEMessGet(getIt()));

  // 2. Repository
  getIt.registerLazySingleton<REPConversation>(() => REPConversationImpl(getIt()));
  getIt.registerLazySingleton<REPMessage>(() => REPMessageImpl(getIt()));

  // 3. DataSource
  getIt.registerLazySingleton<LDSConversation>(() => LDSConversationImpl());
  getIt.registerLazySingleton<LDSMessage>(() => LDSMessageImpl());
}
