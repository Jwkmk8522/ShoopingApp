import 'package:flutter/material.dart';

class Themee with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode {
    return _themeMode;
  }

  void toggleTheme(bool isLightMode) {
    _themeMode = isLightMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
