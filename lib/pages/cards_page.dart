import 'package:flutter/material.dart' hide Card;
import 'package:provider/provider.dart';

import '../models/collection.dart';
import '../models/card.dart';

void main() {
  runApp(const CardsPage());
}

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  Set<int> selectedCardIds = {};
  Set<int> selectedDeckIds = {};
  bool selectMode = false;

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  void fetchCards() {
    context.read<Collection>().fetchAllCards();
  }

  void filterCards(database) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Filter Cards'),
              content: SingleChildScrollView(
                child: DataTable(
                  showCheckboxColumn: true,
                  columns: const [
                    DataColumn(label: Text('Deck')),
                    DataColumn(label: Text('Count')),
                  ],
                  rows: database.currentDecks.map<DataRow>((deck) {
                    final isSelected = selectedDeckIds.contains(deck.id);
                    return DataRow(
                      selected: isSelected,
                      cells: [
                        DataCell(Text(deck.name)),
                        DataCell(Text(deck.cards.length.toString())),
                      ],
                      onSelectChanged: (bool? value) {
                        setState(() {
                          if (isSelected) {
                            selectedDeckIds.remove(deck.id);
                          } else {
                            selectedDeckIds.add(deck.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Filter'),
                  onPressed: () {
                    context.read<Collection>().fetchCardsFromDeckList(
                      selectedDeckIds.toList(),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void deleteSelectedCards() {
    if (selectedCardIds.isNotEmpty) {
      for (int cardId in selectedCardIds) {
        context.read<Collection>().deleteCard(cardId);
      }
      setState(() {
        selectedCardIds.clear();
        selectMode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;

    final database = context.watch<Collection>();
    List<Card> currentCards = database.currentCards;

    return Scaffold(
      appBar: selectMode
          ? AppBar(
              title: Text('${selectedCardIds.length} selected'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    selectMode = false;
                    selectedCardIds.clear();
                  });
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    if (selectedCardIds.isNotEmpty) {
                      deleteSelectedCards();
                    }
                  },
                ),
              ],
            )
          : AppBar(
              title: const Text('Cards'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => filterCards(database),
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
      body: SingleChildScrollView(
        child: DataTable(
          dataRowColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return Colors.red.withValues(alpha: 0.5);
            }
            return null;
          }),
          showCheckboxColumn: false,
          columnSpacing: 20.0,
          horizontalMargin: 20.0,
          columns: [
            DataColumn(label: Text('Front')),
            DataColumn(label: Text('Back')),
            DataColumn(label: Text('Deck')),
          ],
          rows: currentCards.map<DataRow>((card) {
            final isSelected = selectedCardIds.contains(card.id);

            return DataRow(
              selected: isSelected,
              cells: [
                DataCell(SizedBox(width: width / 3, child: Text(card.front))),
                DataCell(SizedBox(width: width / 3, child: Text(card.back))),
                DataCell(
                  SizedBox(
                    width: width / 3,
                    child: Text(card.deck.value?.name ?? 'No Deck'),
                  ),
                ),
              ],
              onLongPress: () {
                //select card for delete
                setState(() {
                  selectMode = true;
                  selectedCardIds.add(card.id);
                });
              },
              onSelectChanged: (bool? value) {
                if (selectMode) {
                  setState(() {
                    if (isSelected) {
                      selectedCardIds.remove(card.id);
                      if (selectedCardIds.isEmpty) {
                        selectMode = value!;
                      }
                    } else {
                      selectedCardIds.add(card.id);
                    }
                  });
                } else {
                  Navigator.pushNamed(
                    context,
                    '/card-editor',
                    arguments: card.id,
                  );
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
