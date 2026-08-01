import 'package:flutter/material.dart';

/// Abstract repository for theme mode management.
abstract class ThemeRepository {
  ThemeMode get themeMode;
  bool get isDarkMode;

  void toggleTheme();
  void setThemeMode(ThemeMode mode);
}
