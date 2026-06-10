import 'package:flutter/material.dart';
import 'package:temp_app/models/deck.dart';
import 'package:temp_app/pages/cards_page.dart';
import 'package:temp_app/pages/settings_page.dart';
import 'package:temp_app/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'pages/decks_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Deck.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Deck()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
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
      home: const DecksPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/decks': (context) => const DecksPage(),
        '/cards': (context) => const CardsPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
