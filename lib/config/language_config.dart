import 'dart:ui';

class LanguageConfig {
  //->  Danh sách ngôn ngữ được hỗ trợ
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('vi', 'VN'),
  ];

  //->  Ngôn ngữ mặc định
  static const Locale defaultLocale = Locale('vi', 'VN');
}
