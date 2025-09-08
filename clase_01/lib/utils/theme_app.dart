import 'package:flutter/material.dart';

class ThemeApp {
  static ThemeData darkTheme() {
    final theme = ThemeData.dark().copyWith(
        colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: Colors.grey,
            onPrimary: Colors.amber,
            secondary: Colors.black12,
            onSecondary: Colors.redAccent,
            error: Colors.red,
            onError: Colors.red,
            surface: const Color.fromARGB(255, 224, 176, 231),
            onSurface: const Color.fromARGB(255, 65, 1, 107)));
    return theme;
  }

  static ThemeData lightTheme() {
    final theme = ThemeData.light().copyWith(
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.white,
            onPrimary: Colors.purple,
            secondary: Colors.grey,
            onSecondary: Colors.red,
            error: Colors.red,
            onError: Colors.red,
            surface: const Color.fromARGB(255, 224, 176, 231),
            onSurface: const Color.fromARGB(255, 65, 1, 107)));
    return theme;
  }
}
