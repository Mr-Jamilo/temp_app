import 'package:flutter/material.dart';
import 'package:temp_app/theme/theme.dart';
import 'package:temp_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/decks.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Decks(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}