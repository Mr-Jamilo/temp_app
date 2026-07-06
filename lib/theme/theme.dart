import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarThemeData(backgroundColor: Colors.blue),
  menuTheme: MenuThemeData(
    style: MenuStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
  ),
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.blue,
    secondary: Colors.indigo,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarThemeData(backgroundColor: Colors.black),
  menuTheme: MenuThemeData(
    style: MenuStyle(backgroundColor: WidgetStatePropertyAll(Colors.grey[800])),
  ),
  colorScheme: ColorScheme.dark(
    surface: Colors.black,
    primary: Colors.grey,
    secondary: Colors.blue,
  ),
);
