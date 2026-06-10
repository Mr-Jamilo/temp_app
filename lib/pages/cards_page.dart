import 'package:flutter/material.dart';

void main() {
  runApp(const CardsPage());
}

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cards')),
      drawer: Drawer(
        child: ListView(
          //padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Decks'),
              onTap: () {
                // handle the tap
                Navigator.pop(context);
                Navigator.pushReplacementNamed(
                  context,
                  '/decks',
                ); // close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Card Browser'),
              onTap: () {
                // handle the tap
                Navigator.pop(context); // close the drawer
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
      body: const Center(child: Text('Cards Page')),
    );
  }
}
