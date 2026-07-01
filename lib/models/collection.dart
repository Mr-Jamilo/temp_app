import 'package:flutter/material.dart' hide Card;
import 'package:isar/isar.dart';
import 'package:temp_app/models/card.dart';
import 'package:temp_app/models/deck.dart';
import 'package:path_provider/path_provider.dart';

class Collection extends ChangeNotifier {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([DeckSchema, CardSchema], directory: dir.path);
  }

  final List<Deck> currentDecks = [];
  final List<Card> currentCards = [];

  Future<void> createDeck(String text) async {
    final newDeck = Deck(name: text);
    await isar.writeTxn(() => isar.decks.put(newDeck));
    fetchDecks();
  }

  Future<void> fetchDecks() async {
    final fetchedDecks = await isar.decks.where().findAll();
    currentDecks.clear();
    currentDecks.addAll(fetchedDecks);
    notifyListeners();
  }

  Future<void> updateDeckName(int id, String newName) async {
    final existingDeck = await isar.decks.get(id);
    if (existingDeck != null) {
      existingDeck.name = newName;
      await isar.writeTxn(() => isar.decks.put(existingDeck));
      await fetchDecks();
    }
  }

  Future<void> deleteDeck(int id) async {
    await isar.writeTxn(() => isar.decks.delete(id));
    await fetchDecks();
  }

  Future<void> createCard(int deckId, String front, String back) async {
    final newCard = Card(front: front, back: back);
    await isar.writeTxn(() async {
      final deck = await isar.decks.get(deckId);
      if (deck != null) {
        await isar.cards.put(newCard);
        deck.cards.add(newCard);
        await isar.decks.put(deck);
      }
    });
    fetchCards(deckId);
  }

  Future<void> fetchCards(int deckId) async {
    final deck = await isar.decks.get(deckId);
    if (deck != null) {
      final fetchedCards = deck.cards.toList();
      currentCards.clear();
      currentCards.addAll(fetchedCards);
      notifyListeners();
    }
  }

  Future<void> updateCard(int cardId, String newFront, String newBack) async {
    final existingCard = await isar.cards.get(cardId);
    if (existingCard != null) {
      existingCard.front = newFront;
      existingCard.back = newBack;
      await isar.writeTxn(() => isar.cards.put(existingCard));
      // Assuming you have a way to get the deckId for the card
      // You might need to adjust this part based on your data model
      final decks = await isar.decks
          .where()
          .filter()
          .cards((q) => q.idEqualTo(cardId))
          .findAll();
      if (decks.isNotEmpty) {
        fetchCards(decks.first.id);
      }
    }
  }

  Future<void> deleteCard(int cardId) async {
    await isar.writeTxn(() => isar.cards.delete(cardId));
    // Assuming you have a way to get the deckId for the card
    // You might need to adjust this part based on your data model
    final decks = await isar.decks
        .where()
        .filter()
        .cards((q) => q.idEqualTo(cardId))
        .findAll();
    if (decks.isNotEmpty) {
      fetchCards(decks.first.id);
    }
  }
}
