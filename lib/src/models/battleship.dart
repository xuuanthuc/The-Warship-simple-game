class Battleship {
  final String horizontalSprite;
  final String verticalSprite;
  final int size;
  BattleshipSymmetric symmetric;

  Battleship({
    required this.horizontalSprite,
    required this.verticalSprite,
    required this.size,
    required this.symmetric,
  });
}

enum BattleshipSymmetric {
  horizontal,
  vertical,
}
