import 'package:template/src/models/battleship.dart';
import 'package:template/src/models/blue_sea.dart';

enum BattleSquareType {
  sea,
  ship,
}

enum BattleSquareStatus {
  undefined,
  determined,
}

class SeaInBattle {
  final BlueSea blueSea;
  final BattleSquareType type;
  BattleSquareStatus status;

  SeaInBattle({
    required this.blueSea,
    required this.type,
    required this.status,
  });
}

class ShipInBattle {
  final Battleship ship;
  final BlueSea? centerPoint;
  final double angle;
  final List<BlueSea> positions;

  ShipInBattle({
    required this.positions,
    required this.angle,
    required this.centerPoint,
    required this.ship,
  });

  @override
  String toString() {
    return """
    "ship": {
      ${ship.id},
      ${ship.sprite},
      ${ship.size},
    },
    "centerPoint": {
      ${centerPoint?.coordinates},
      ${centerPoint?.vector2},
    },
    "angle": {
      ${angle},
    },
    "positions": {
      ${positions},
    },
    """;
  }
}
