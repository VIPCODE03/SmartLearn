import 'package:get_it/get_it.dart';
import 'package:smart_learn/features/assistant/assistant_injection.dart';
import 'package:smart_learn/features/calendar/calendar_ijnection.dart';
import 'package:smart_learn/features/file/appfile_injection.dart';
import 'package:smart_learn/features/flashcard/flashcard_injection.dart';
import 'package:smart_learn/features/quiz/quiz_injection.dart';
import 'package:smart_learn/features/subject/subject_injection.dart';
import 'core_injection.dart';
import '../../features/focus/focus_injection.dart';

final getIt = GetIt.instance;

Future<void> initAppDI() async {
  await initCoreDI(getIt);

  await initFocusDI(getIt);
  await initCalendarDI(getIt);
  await initAssistantDI(getIt);
  await initFileDI(getIt);
  await initSubjectDI(getIt);
  await initQuizDI(getIt);
  await initFlashCardDI(getIt);
}
