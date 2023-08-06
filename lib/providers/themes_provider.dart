import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode mode;
  ThemeProvider({this.mode = ThemeMode.light});

  void toggleMode() {
    mode = mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
