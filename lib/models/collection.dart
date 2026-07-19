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
      await isar.cards.put(newCard);
      final selectedDeck = await isar.decks.get(deckId);

      if (selectedDeck != null) {
        selectedDeck.cards.add(newCard);
        await selectedDeck.cards.save();
      }
    });
    fetchAllCards();
  }

  Card? fetchCard(int cardId) {
    try {
      return currentCards.firstWhere((card) => card.id == cardId);
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchAllCards() async {
    final fetchedCards = await isar.cards.where().findAll();
    await Future.wait(fetchedCards.map((card) => card.deck.load()));

    currentCards.clear();
    currentCards.addAll(fetchedCards);
    notifyListeners();
  }

  Future<void> fetchCardsFromDeck(int deckId) async {
    final deck = await isar.decks.get(deckId);
    if (deck != null) {
      final fetchedCards = deck.cards.toList();
      await Future.wait(fetchedCards.map((card) => card.deck.load()));
      currentCards.clear();
      currentCards.addAll(fetchedCards);
      notifyListeners();
    }
  }

  Future<void> fetchCardsFromDeckList(List<int> deckList) async {
    final fetchedCards = await isar.cards
        .filter()
        .anyOf(deckList, (q, int deckId) => q.deck((q) => q.idEqualTo(deckId)))
        .findAll();
    await Future.wait(fetchedCards.map((card) => card.deck.load()));

    currentCards.clear();
    currentCards.addAll(fetchedCards);
    notifyListeners();
  }

  Future<void> updateCard(
    int cardId,
    String newFront,
    String newBack,
    int newDeck,
  ) async {
    final existingCard = await isar.cards.get(cardId);
    if (existingCard != null) {
      existingCard.front = newFront;
      existingCard.back = newBack;
      existingCard.deck.value = await isar.decks.get(newDeck);
      await isar.writeTxn(() async {
        await isar.cards.put(existingCard);
        await existingCard.deck.save();
      });
      await fetchAllCards();
    }
  }

  Future<void> deleteCard(int cardId) async {
    await isar.writeTxn(() => isar.cards.delete(cardId));
    await fetchAllCards();
  }
}
