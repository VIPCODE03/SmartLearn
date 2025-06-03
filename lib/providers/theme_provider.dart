import 'package:flutter/material.dart';
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
  }

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;

  static const List<Color> primaryColors = [
    Color(0xFF007AFF), // Xanh dương
    Color(0xFFFF3B30), // Đỏ
    Color(0xFF34C759), // Xanh lá
    Color(0xFFFF9500), // Cam
    Color(0xFF5856D6), // Tím
  ];

  static const List<Color> secondaryColors = [
    Color(0xFF34C759), // Xanh lá
    Color(0xFFFFCC00), // Vàng
    Color(0xFFFF2D55), // Hồng
    Color(0xFF5AC8FA), // Xanh nhạt
    Color(0xFFC0C0C0), // Xám bạc
  ];

  // **Chuyển đổi sáng/tối**
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _updateTheme();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkMode", _isDarkMode);
  }

  // **Cập nhật màu theme**
  Future<void> updateTheme(Color newPrimary, Color newSecondary) async {
    _primaryColor = newPrimary;
    _secondaryColor = newSecondary;
    _updateTheme();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("primaryColor", newPrimary.value);
    prefs.setInt("secondaryColor", newSecondary.value);
  }

  // **Tải theme từ SharedPreferences**
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool("isDarkMode") ?? false;
    _primaryColor = Color(prefs.getInt("primaryColor") ?? ThemeConfig.defaultPrimaryColor.value);
    _secondaryColor = Color(prefs.getInt("secondaryColor") ?? ThemeConfig.defaultSecondaryColor.value);
    _updateTheme();
    notifyListeners();
  }

  // **Cập nhật theme**
  void _updateTheme() {
    _themeData = _isDarkMode
        ? ThemeConfig.darkTheme(_primaryColor, _secondaryColor)
        : ThemeConfig.lightTheme(_primaryColor, _secondaryColor);
  }
}
