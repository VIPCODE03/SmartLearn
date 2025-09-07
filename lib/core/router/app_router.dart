import 'package:smart_learn/features/aihomework/aihomework_provider.dart';
import 'package:smart_learn/features/assistant/assistant_provider.dart';
import 'package:smart_learn/features/calculator/calculator_provider.dart';
import 'package:smart_learn/features/calendar/calendar_provider.dart';
import 'package:smart_learn/features/file/file_provider.dart';
import 'package:smart_learn/features/flashcard/flashcard_provider.dart';
import 'package:smart_learn/features/focus/focus_provider.dart';
import 'package:smart_learn/features/game/game_provider.dart';
import 'package:smart_learn/features/quiz/quiz_provider.dart';
import 'package:smart_learn/features/subject/subject_provider.dart';
import 'package:smart_learn/features/translate/translate_provider.dart';
import 'package:smart_learn/features/user/user_provider.dart';

final appRouter = AppRouter.instance;

class AppRouter {
  static final AppRouter _singleton = AppRouter._internal();
  AppRouter._internal();
  static AppRouter get instance => _singleton;

  IAssistantRouter get assistant => AssistantProvider.instance.router;
  ICalendarRouter get calendar => CalendarProvider.instance.router;
  ICalculatorRouter get calculator => CalculatorProvider.instance.router;
  ITranslateRouter get translate => TranslateProvider.instance.router;
  IFocusRouter get focus => FocusProvider.instance.router;
  ISubjectRouter get subject => SubjectProvider.instance.router;
  IFileRouter get file => FileProvider.instance.router;
  IQuizRouter get quiz => QuizProvider.instance.router;
  IAiHomeWorkRouter get aiHomework => AiHomeWorkProvider.instance.router;
  IFlashCardRouter get flashCard => FlashCardProvider.instance.router;
  IGameRouter get game => GameProvider.instance.router;
  IUserRouter get user => UserProvider.instance.router;
}
