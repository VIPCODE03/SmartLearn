import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_awesome_calculator/flutter_awesome_calculator.dart';
import 'package:provider/provider.dart';
import 'package:smart_learn/a_test/schedule.dart';
import 'package:smart_learn/a_test/state.dart';
import 'package:smart_learn/config/app_config.dart';
import 'package:smart_learn/data/models/file/file.dart';
import 'package:smart_learn/data/models/quiz/a_quiz.dart';
import 'package:smart_learn/data/models/quiz/b_choice_quiz.dart';
import 'package:smart_learn/data/models/quiz/b_multi_choice_quiz.dart';
import 'package:smart_learn/data/models/quiz/c_quiz_result.dart';
import 'package:smart_learn/global.dart';
import 'package:smart_learn/providers/theme_provider.dart';
import 'package:smart_learn/services/language_service.dart';
import 'package:smart_learn/ui/screens/a_mainscreen/pages/3_schedule/a_schedule.dart';
import 'package:smart_learn/ui/screens/a_mainscreen/pages/4_profile/a_profile.dart';
import 'package:smart_learn/ui/screens/b_flashcard_manage_screen/a_flashcardsetmanage_screen.dart';
import 'package:smart_learn/ui/screens/b_quizscreen/manage/a_quiz_manage_screen.dart';
import 'package:smart_learn/ui/widgets/utilities_widget/ai_chat_widget.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_learn/ui/widgets/bouncebutton_widget.dart';

import '../ui/screens/a_mainscreen/pages/1_home/a_home_page.dart';
import '../ui/screens/b_quizscreen/play/c_quiz_result_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN', null);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageService()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const SmartLearn(),
      ),
    );
  });
}

class SmartLearn extends StatelessWidget {
  const SmartLearn({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    globalLanguage = languageService.textGlobal;

    return  MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: AppConfig.isDebug,
        locale: languageService.locale,
        theme: themeProvider.themeData,
        home: Scaffold(
            // body: QuizListScreen(json: null, name: 'ngu')
          // body: QuizScreen.review(jsonQuiz: jsonTest)
          body: SizedBox()
        )
    );
  }
}