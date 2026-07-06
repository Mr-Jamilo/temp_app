import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/collection.dart';
import '../models/deck.dart';

void main() {
  runApp(const CardEditorPage(cardID: -1));
}

class CardEditorPage extends StatefulWidget {
  final int cardID;
  const CardEditorPage({super.key, required this.cardID});

  @override
  State<CardEditorPage> createState() => _CardEditorPageState();
}

class _CardEditorPageState extends State<CardEditorPage> {
  late FleatherController frontController;
  late FleatherController backController;
  late FleatherController currentController;
  final FocusNode frontFocusNode = FocusNode();
  final FocusNode backFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    frontController = FleatherController(document: ParchmentDocument());
    backController = FleatherController(document: ParchmentDocument());
    currentController = frontController;
    frontFocusNode.addListener(_updateCurrentController);
    backFocusNode.addListener(_updateCurrentController);
    fetchDecks();
  }

  void _updateCurrentController() {
    if (frontFocusNode.hasFocus && currentController != frontController) {
      setState(() {
        currentController = frontController;
      });
    } else if (backFocusNode.hasFocus && currentController != backController) {
      setState(() {
        currentController = backController;
      });
    }
  }

  @override
  void dispose() {
    frontController.dispose();
    backController.dispose();
    super.dispose();
  }

  void submitCard() {
    // Implement card creation logic here
  }

  void fetchDecks() {
    context.read<Collection>().fetchDecks();
  }

  @override
  Widget build(BuildContext context) {
    final database = context.watch<Collection>();
    List<Deck> currentDecks = database.currentDecks;
    int dropdownValue = currentDecks.isNotEmpty ? currentDecks.first.id : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cardID == -1 ? 'Add Card' : 'Edit Card'),
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
        child: Form(
          child: Column(
            children: [
              DropdownMenu(
                label: const Text('Select A Deck'),
                expandedInsets: EdgeInsets.zero,
                enableSearch: true,
                initialSelection: 0,
                dropdownMenuEntries: currentDecks
                    .map(
                      (deck) =>
                          DropdownMenuEntry(value: deck.id, label: deck.name),
                    )
                    .toList(),
                onSelected: (deckID) {
                  setState(() {
                    dropdownValue = deckID!;
                  });
                },
              ),
              FleatherToolbar.basic(controller: currentController),
              const SizedBox(height: 8),
              const Text(
                'Front',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: currentController == frontController
                          ? Colors.blue
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FleatherEditor(
                    controller: frontController,
                    focusNode: frontFocusNode,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: currentController == backController
                          ? Colors.blue
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FleatherEditor(
                    controller: backController,
                    focusNode: backFocusNode,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
