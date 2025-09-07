
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

final appWidget = AppWidget.instance;

class AppWidget {
  static final AppWidget _singleton = AppWidget._internal();
  AppWidget._internal();
  static AppWidget get instance => _singleton;

  ICalendarWidget get calendar => CalendarProvider.instance.widget;
  IFocusWidget get focus => FocusProvider.instance.widget;
  ITranslateWidget get translate => TranslateProvider.instance.widget;
  ICalculatorWidget get calculator => CalculatorProvider.instance.widget;
  IAssistantWidget get assistant => AssistantProvider.instance.widget;
  ISubjectWidget get subject => SubjectProvider.instance.widget;
  IFileWidget get file => FileProvider.instance.widget;
  IQuizWidget get quiz => QuizProvider.instance.widget;
  IAiHomeWorkWidget get aiHomework => AiHomeWorkProvider.instance.widget;
  IFlashCardWidget get flashCard => FlashCardProvider.instance.widget;
  IGameWidget get game => GameProvider.instance.widget;
  IUserWidget get user => UserProvider.instance.widget;
}
