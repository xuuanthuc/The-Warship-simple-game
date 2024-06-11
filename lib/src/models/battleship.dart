class Battleship {
  final String sprite;
  final int size;

  Battleship({
    required this.sprite,
    required this.size,
  });
}

enum BattleshipSymmetric {
  horizontal,
  vertical,
}
