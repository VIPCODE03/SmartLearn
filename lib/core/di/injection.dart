import 'package:get_it/get_it.dart';
import 'core_injection.dart';
import '../../features/focus/focus_injection.dart';

final getIt = GetIt.instance;

Future<void> initAppDI() async {
  await initCoreDI(getIt);

  await initFocusDI(getIt);
}
