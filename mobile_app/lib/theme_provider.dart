import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Default theme mode
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Notify listeners to rebuild
  }

  // Custom light theme
  ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.lightBlue,
      primaryColorLight: Colors.lightBlue[50],
      primaryColorDark: Colors.blue,
      secondaryHeaderColor: Colors.blueGrey,

      brightness: Brightness.light,
      // Add other customizations here
      appBarTheme: AppBarTheme(
        color: Colors.lightBlue,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 25.0),
      ),
      // Define other properties like button themes, text themes, etc.
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            color: Colors.blueGrey,
            fontSize: 24.0,
            fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(color: Colors.white, fontSize: 24.0),
        titleMedium: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
        labelMedium: TextStyle(
            color: Colors.grey[800],
            fontSize: 18,
            fontWeight: FontWeight.normal),
        labelSmall: TextStyle(
            color: Colors.blueGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline),
      ),
      // Cards
      cardColor: Colors.grey[50],
    );
  }

  // Custom dark theme
  ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.lightBlue,
      primaryColorLight: Colors.lightBlue[50],
      primaryColorDark: Colors.blue,
      secondaryHeaderColor: Colors.blueGrey,

      brightness: Brightness.dark,
      // Add other customizations here
      appBarTheme: AppBarTheme(
        color: Colors.lightBlue,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 25.0),
      ),
      // Define other properties like button themes, text themes, etc.
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            color: Colors.lightBlue,
            fontSize: 24.0,
            fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(color: Colors.white, fontSize: 24.0),
        titleMedium: TextStyle(color: Colors.white70, fontSize: 18.0),
        labelMedium: TextStyle(
            color: Colors.grey[200],
            fontSize: 18,
            fontWeight: FontWeight.normal),
        labelSmall: TextStyle(
            color: Colors.blueGrey[200],
            fontSize: 12,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline),
      ),
      // Cards
      cardColor: Colors.blueGrey[900],
    );
  }
}
