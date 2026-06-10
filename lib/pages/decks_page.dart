import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temp_app/theme/theme_provider.dart';
import 'package:temp_app/widgets/expandable_fab.dart';

void main() {
  runApp(DecksPage());
}

class DecksPage extends StatefulWidget {
  const DecksPage({super.key});

  @override
  State<DecksPage> createState() => _DecksPageState();
}

class _DecksPageState extends State<DecksPage> {
  void _showAction(BuildContext context, int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Action $index')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Anki Decks'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search Decks',
            onPressed: () {
              // handle the press
            },
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sync',
            onPressed: () {
              // handle the press
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More',
            onPressed: () {
              // handle the press
            },
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(Icons.add),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
