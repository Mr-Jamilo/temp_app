import 'package:flutter/material.dart';

void main() {
  runApp(SettingsPage());
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
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
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Settings Page')),
    );
  }
}
