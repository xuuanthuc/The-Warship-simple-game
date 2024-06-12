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

class Battle {
  final BlueSea blueSea;
  final BattleSquareType type;
  BattleSquareStatus status;

  Battle({
    required this.blueSea,
    required this.type,
    required this.status,
  });
}
