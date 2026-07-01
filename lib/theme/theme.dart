import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarThemeData(backgroundColor: Colors.blue),
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.blue,
    secondary: Colors.indigo,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarThemeData(backgroundColor: Colors.black),
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.grey,
    secondary: Colors.blue,
  ),
);
