import 'package:isar/isar.dart';
import 'package:temp_app/models/card.dart';

part 'deck.g.dart';

@collection
class Deck {
  Id id = Isar.autoIncrement;
  String name;
  final cards = IsarLinks<Card>();

  Deck({required this.name});
}
