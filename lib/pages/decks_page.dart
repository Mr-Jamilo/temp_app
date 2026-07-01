import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temp_app/models/collection.dart';
import 'package:temp_app/theme/theme_provider.dart';
import 'package:temp_app/widgets/expandable_fab.dart';

import '../models/deck.dart';

void main() {
  runApp(DecksPage());
}

class DecksPage extends StatefulWidget {
  const DecksPage({super.key});

  @override
  State<DecksPage> createState() => _DecksPageState();
}

class _DecksPageState extends State<DecksPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDecks();
  }

  void createDeck() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Deck'),
          content: TextField(controller: textController),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                context.read<Collection>().createDeck(textController.text);
                textController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void renameDeck(int deckId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rename Deck'),
          content: TextField(controller: textController),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Rename'),
              onPressed: () {
                context.read<Collection>().updateDeckName(
                  deckId,
                  textController.text,
                );
                textController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteDeck(int deckId) {
    context.read<Collection>().deleteDeck(deckId);
  }

  void fetchDecks() {
    context.read<Collection>().fetchDecks();
  }

  void createCard() {}

  void _showAction(BuildContext context, int index) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Action $index')));
  }

  @override
  Widget build(BuildContext context) {
    final database = context.watch<Collection>();
    List<Deck> currentDecks = database.currentDecks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Decks'),
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
      drawer: Drawer(
        child: ListView(
          //padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Decks'),
              onTap: () {
                // handle the tap
                Navigator.pop(context); // close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Card Browser'),
              onTap: () {
                // handle the tap
                Navigator.pop(context); // close the drawer
                Navigator.pushReplacementNamed(
                  context,
                  '/cards',
                ); // navigate to cards page
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // handle the tap
                Navigator.pop(context); // close the drawer
                Navigator.pushReplacementNamed(
                  context,
                  '/settings',
                ); // navigate to settings
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: currentDecks.length,
        itemBuilder: (context, index) {
          final deck = currentDecks[index];
          return ListTile(
            title: Text(
              deck.name,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Navigate to the deck's cards page
              Navigator.pushNamed(context, '/deck/${deck.id}');
            },
            onLongPress: () {
              // Show options to edit or delete the deck
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(deck.name),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Rename'),
                          onTap: () {
                            Navigator.of(context).pop();
                            renameDeck(deck.id);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete'),
                          onTap: () {
                            // Handle delete
                            deleteDeck(deck.id);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(Icons.post_add),
          ),
          ActionButton(
            onPressed: () => createDeck(),
            icon: const Icon(Icons.library_add),
          ),
        ],
      ),
    );
  }
}
