class GameCard {
  final String name;
  final String package;
  final int cost;
  final List<CardType> types;

  GameCard(this.name, this.package, this.cost, this.types);
}

enum CardType {
  money,
  action,
  points,
  duration,
  attack,
  reserve,
  traveler,
  reaction;

  static CardType fromString(String type) {
    try {
      return CardType.values.firstWhere((element) => element.name == type);
    } catch (e) {
      print(type);
      throw e;
    }
  }
}
