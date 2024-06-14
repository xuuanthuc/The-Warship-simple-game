import 'package:template/src/models/occupied_block.dart';
import 'package:template/src/models/empty_block.dart';

enum BattleSquareType {
  empty,
  occupied,
}

enum BattleSquareStatus {
  undefined,
  determined,
}

class EmptyBattleSquare {
  final EmptyBlock block;
  final BattleSquareType type;
  BattleSquareStatus status;

  EmptyBattleSquare({
    required this.block,
    required this.type,
    required this.status,
  });
}

class OccupiedBattleSquare {
  final OccupiedBlock block;
  final EmptyBlock? targetPoint;
  final double angle;
  final List<EmptyBlock> overlappingPositions;

  OccupiedBattleSquare({
    required this.overlappingPositions,
    required this.angle,
    required this.targetPoint,
    required this.block,
  });

  @override
  String toString() {
    return """
    "ship": {
      ${block.id},
      ${block.sprite},
      ${block.size},
    },
    "centerPoint": {
      ${targetPoint?.coordinates},
      ${targetPoint?.vector2},
    },
    "angle": {
      ${angle},
    },
    "positions": {
      ${overlappingPositions},
    },
    """;
  }
}
