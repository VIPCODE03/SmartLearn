import 'package:flutter/material.dart';

class ThemeConfig {
  static const Color defaultPrimaryColor = Color(0xFF007AFF);
  static const Color defaultSecondaryColor = Color(0xFF34C759);

  // ** theme sáng**
  static ThemeData lightTheme(Color primary, Color secondary) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      fontFamily: 'Roboto',
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
      ),
    );
  }

  // ** theme tối**
  static ThemeData darkTheme(Color primary, Color secondary) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      fontFamily: 'Roboto',
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
      ),
    );
  }
}
