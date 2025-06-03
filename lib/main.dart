import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_learn/config/app_config.dart';
import 'package:smart_learn/providers/theme_provider.dart';
import 'package:smart_learn/services/language_service.dart';
import 'package:smart_learn/ui/screens/a_mainscreen/mainscreen.dart';
import 'global.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: AppConfig.appName,
      debugShowCheckedModeBanner: AppConfig.isDebug,
      locale: languageService.locale,
      theme: themeProvider.themeData,
      home: const MainScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
    );
  }
}
