import 'package:flutter/material.dart';
import 'package:smart_learn/app/languages/language.dart';
import 'package:smart_learn/app/languages/language_en.dart';
import 'package:smart_learn/app/languages/language_zh.dart';
import '../languages/language_vi.dart';

late AppLanguage globalLanguage;

class AppLanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('vi', 'VN');
  Locale get locale => _locale;
  String get localeString => '${locale.languageCode}_${locale.countryCode}';

  AppLanguageProvider() {
    globalLanguage = textGlobal;
  }

  static List<Locale> supportedLocales = [
    const Locale('vi', 'VN'),
    const Locale('en', 'US'),
    const Locale('zh', 'CN'),
  ];

  AppLanguage get textGlobal {
    switch (_locale.languageCode) {
      case 'vi':
        return ViLanguage();
      case 'en':
        return EnLanguage();
      case 'zh':
        return ZhLanguage();
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