import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;

  switchMode() {
    isDark = !isDark;
    notifyListeners();
  }
}
