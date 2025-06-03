import 'package:flutter/material.dart';
import 'package:smart_learn/config/language_config.dart';
import 'package:smart_learn/languages/a_global_language.dart';
import 'package:smart_learn/languages/en_language.dart';
import '../languages/vi_language.dart';

class LanguageService with ChangeNotifier {
  Locale _locale = LanguageConfig.defaultLocale;

  Locale get locale => _locale;

  // ✅ Lấy class ngôn ngữ tương ứng
  GlobalLanguage get textGlobal {
    switch (_locale.languageCode) {
      case 'vi':
        return ViLanguage();
      case 'en':
        return EnLanguage();
      default:
        return ViLanguage();
    }
  }

  // ✅ Thay đổi ngôn ngữ
  Future<void> changeLanguage(Locale locale) async {
    _locale = locale;
    notifyListeners();
  }
}
