import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;

  void changeTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  bool get isDarkTheme => _isDark;
}
