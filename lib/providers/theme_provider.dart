import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme_config.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode;
  Color _primaryColor;
  Color _secondaryColor;

  ThemeProvider()
      : _isDarkMode = false,
        _primaryColor = ThemeConfig.defaultPrimaryColor,
        _secondaryColor = ThemeConfig.defaultSecondaryColor,
        _themeData = ThemeConfig.lightTheme(
          ThemeConfig.defaultPrimaryColor,
          ThemeConfig.defaultSecondaryColor,
        ) {
    loadTheme();
    _setStatusBar();
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;

  static const List<Color> primaryColors = [
    Color(0xFF007AFF), // Xanh dương (iOS Blue)
    Color(0xFFFF3B30), // Đỏ
    Color(0xFF34C759), // Xanh lá
    Color(0xFFFF9500), // Cam
    Color(0xFF5856D6), // Tím

    Color(0xFFFFCC00), // Vàng
    Color(0xFF5AC8FA), // Xanh trời nhạt
    Color(0xFFAF52DE), // Tím hồng
    Color(0xFFFF2D55), // Hồng đậm
    Color(0xFF8E8E93), // Xám trung tính

    Color(0xFF1ABC9C), // Ngọc lam
    Color(0xFF2ECC71), // Xanh lá sáng
    Color(0xFF3498DB), // Xanh biển
    Color(0xFF9B59B6), // Tím đậm
    Color(0xFF34495E), // Xám xanh đậm

    Color(0xFFF1C40F), // Vàng chanh
    Color(0xFFE67E22), // Cam đất
    Color(0xFFE74C3C), // Đỏ đất
    Color(0xFF95A5A6), // Xám bạc
    Color(0xFF7F8C8D), // Xám đậm
  ];

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
  Future<void> updateTheme(Color newPrimary, Color newSecondary) async {
    _primaryColor = newPrimary;
    _secondaryColor = newSecondary;
    _updateTheme();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("primaryColor", newPrimary.toARGB32());
    prefs.setInt("secondaryColor", newSecondary.toARGB32());
  }

  //- Tải theme cache ----------------------------------------------------------
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool("isDarkMode") ?? false;
    _primaryColor = Color(prefs.getInt("primaryColor") ?? ThemeConfig.defaultPrimaryColor.toARGB32());
    _secondaryColor = Color(prefs.getInt("secondaryColor") ?? ThemeConfig.defaultSecondaryColor.toARGB32());
    _updateTheme();
    notifyListeners();
  }

  //- Cập nhật theme -----------------------------------------------------------
  void _updateTheme() {
    _themeData = _isDarkMode
        ? ThemeConfig.darkTheme(_primaryColor, _secondaryColor)
        : ThemeConfig.lightTheme(_primaryColor, _secondaryColor);
  }

  void _setStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: _isDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness: _isDarkMode ? Brightness.dark : Brightness.light,
    ));
  }
}
