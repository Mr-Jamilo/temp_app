import 'package:isar/isar.dart';

part 'card.g.dart';

@Collection()
class Card {
  Id id = Isar.autoIncrement;
  String front;
  String back;

  Card({
    required this.front,
    required this.back,
  });
}