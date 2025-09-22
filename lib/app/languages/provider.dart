import 'package:flutter/material.dart';
import 'package:smart_learn/app/languages/language.dart';
import 'package:smart_learn/app/languages/language_en.dart';
import '../languages/language_vi.dart';

late AppLanguage globalLanguage;

class AppLanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('vi', 'VN');
  Locale get locale => _locale;

  AppLanguageProvider() {
    globalLanguage = textGlobal;
  }

  static List<Locale> supportedLocales = [
    const Locale('vi', 'VN'),
    const Locale('en', 'US'),
  ];

  AppLanguage get textGlobal {
    switch (_locale.languageCode) {
      case 'vi':
        return ViLanguage();
      case 'en':
        return EnLanguage();
      default:
        return ViLanguage();
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    _locale = locale;
    globalLanguage = textGlobal;
    notifyListeners();
  }
}
