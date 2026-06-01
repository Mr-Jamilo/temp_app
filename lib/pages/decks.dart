import 'package:flutter/material.dart';

void main() {
  runApp(Decks());
}

class Decks extends StatelessWidget {
  const Decks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
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
        body: Center(
          child: Container(
            height: 300,
            width: 300,
            color: Colors.red,
            child: Text("hello"),
          ),
        ),
      ),
    );
  }
}
