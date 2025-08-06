import 'package:flutter/material.dart';

class ThemeConfig {
  static const Color defaultPrimaryColor = Color(0xFF007AFF);
  static const Color defaultSecondaryColor = Color(0xFF34C759);

  static ThemeData lightTheme(Color primary, Color secondary) {
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

  static ThemeData darkTheme(Color primary, Color secondary) {
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
}