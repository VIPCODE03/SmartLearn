import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_learn/app/style/color.dart';

class AppTheme extends StatelessWidget {
  final Widget Function(BuildContext, ThemeData) builder;
  const AppTheme({
    super.key,
    required this.builder
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppThemeProvider(),
      child: Consumer<AppThemeProvider>(
        builder: (context, themeProvider, child) {
          return builder(context, themeProvider._themeData);
        },
      )
    );
  }
}

class AppThemeProvider with ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode;
  Color _primaryColor;

  AppThemeProvider()
      : _isDarkMode = false,
        _primaryColor = AppColor.defaultPrimaryColor,
        _themeData = _lightTheme(
          AppColor.defaultPrimaryColor,
        ) {
    loadTheme();
    _setStatusBar();
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  static ThemeData _lightTheme(Color primary) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      primaryColor: primary,
      fontFamily: 'Roboto',

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  static ThemeData _darkTheme(Color primary) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      primaryColor: primary,
      fontFamily: 'Roboto',

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  //- Chuyển đổi sáng/tối ------------------------------------------------------
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _setStatusBar();
    _updateTheme();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", _isDarkMode);
  }

  //- Cập nhật và lưu  ----------------------------------------------------------------
  Future<void> updateTheme(Color newPrimary) async {
    _primaryColor = newPrimary;
    _updateTheme();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("primaryColor", newPrimary.toARGB32());
  }

  //- Tải theme cache ----------------------------------------------------------
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool("isDarkMode") ?? false;
    _primaryColor = Color(prefs.getInt("primaryColor") ?? AppColor.defaultPrimaryColor.toARGB32());
    _updateTheme();
    notifyListeners();
  }

  //- Cập nhật theme -----------------------------------------------------------
  void _updateTheme() {
    _themeData = _isDarkMode
        ? _darkTheme(_primaryColor)
        : _lightTheme(_primaryColor);
  }

  void _setStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: _isDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness: _isDarkMode ? Brightness.dark : Brightness.light,
    ));
  }
}
