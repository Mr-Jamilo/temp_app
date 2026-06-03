import 'package:flutter/material.dart' hide Card;
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:temp_app/models/card.dart';

class Deck extends ChangeNotifier {
  static late Isar isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([CardSchema], directory: dir.path);
  }

  final List<Card> currentCards = [];

  Future<void> addCard(String front, String back) async {
    final newCard = Card(front: front, back: back);
    await isar.writeTxn(() async {
      await isar.cards.put(newCard);
    });
    getCards();
  }

  Future<void> getCards() async {
    List<Card> fetchedCards = await isar.cards.where().findAll();
    currentCards.clear();
    currentCards.addAll(fetchedCards);
    notifyListeners();
  }

  Future<void> updateCard(int id, String? newFront, String? newBack) async {
    final cardToUpdate = await isar.cards.get(id);
    if (cardToUpdate != null) {
      cardToUpdate.front = newFront!;
      cardToUpdate.back = newBack!;
      await isar.writeTxn(() => isar.cards.put(cardToUpdate));
      await getCards();
    }
  }

  Future<void> deleteCard(int id) async {
    await isar.writeTxn(() => isar.cards.delete(id));
    await getCards();
  }
}
