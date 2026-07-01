import 'package:isar/isar.dart';
import 'package:temp_app/models/deck.dart';

part 'card.g.dart';

@collection
class Card {
  Id id = Isar.autoIncrement;
  String front;
  String back;

  @Backlink(to: 'cards')
  final deck = IsarLink<Deck>();

  Card({required this.front, required this.back});
}
