import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = lightTheme;

  static final ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(
      primary: Colors.teal,
      secondary: Colors.tealAccent,
    ),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.teal[50],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Colors.teal,
      secondary: Colors.tealAccent,
    ),
    scaffoldBackgroundColor: Colors.black,
    cardColor: const Color(0xFF0e1111),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0e1111),
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.teal[800],
      foregroundColor: Colors.white,
    ),
  );

  ThemeData get currentTheme => _currentTheme;

  void setLightTheme() {
    _currentTheme = lightTheme;
    notifyListeners();
  }

  void setDarkTheme() {
    _currentTheme = darkTheme;
    notifyListeners();
  }
}
