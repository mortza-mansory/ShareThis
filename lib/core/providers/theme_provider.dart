import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  double _fontScaleFactor = 1.0;

  bool get isDarkMode => _isDarkMode;
  double get fontScaleFactor => _fontScaleFactor;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setFontScale(double scale) {
    if (_fontScaleFactor != scale) {
      _fontScaleFactor = scale;
      notifyListeners();
    }
  }

  void setLightMode() {
    if (_isDarkMode) {
      _isDarkMode = false;
      notifyListeners();
    }
  }

  void setDarkMode() {
    if (!_isDarkMode) {
      _isDarkMode = true;
      notifyListeners();
    }
  }
}