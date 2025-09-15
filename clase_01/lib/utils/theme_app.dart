import 'package:flutter/material.dart';

class ThemeApp {
  static ThemeData darkTheme() {
    final theme = ThemeData.dark().copyWith(
        colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: Color(0xFF10B954),
            onPrimary: Colors.white,
            secondary: Color(0xFF212121),
            onSecondary: Colors.white,
            error: Color(0xFFCF6679),
            onError: Colors.white,
            surface: Color(0xFF121212),
            onSurface: Color(0xFFB3B3B3)),
        scaffoldBackgroundColor: Color(0xFF121212),
        appBarTheme: AppBarTheme(
          color: Color(0xFF212121),
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF10B954),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Color(0xFF212121),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFFB3B3B3),
          ),
        ));
    return theme;
  }

  static ThemeData lightTheme() {
    final theme = ThemeData.light().copyWith(
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF10B954),
            onPrimary: Colors.white,
            secondary: Colors.white,
            onSecondary: Color(0xFF212121),
            error: Color(0xFFCF6679),
            onError: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF535353)),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF212121)),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF10B954),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Color(0xFF212121),
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF535353),
          ),
        ));
    return theme;
  }
}
