import 'package:flutter/material.dart';

void main() {}

class CardEditorPage extends StatefulWidget {
  const CardEditorPage({super.key});

  @override
  State<CardEditorPage> createState() => _CardEditorPageState();
}

class _CardEditorPageState extends State<CardEditorPage> {
  final frontController = TextEditingController();
  final backController = TextEditingController();

  void createCard() {
    // Implement card creation logic here
  }

  void editCard() {
    // Implement card editing logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () {
              // Preview card
            },
          ),
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              // Save the card
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: frontController,
              decoration: const InputDecoration(labelText: 'Front'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: backController,
              decoration: const InputDecoration(labelText: 'Back'),
            ),
          ],
        ),
      ),
    );
  }
}
