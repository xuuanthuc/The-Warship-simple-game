import 'package:template/src/models/occupied_block.dart';
import 'package:template/src/models/empty_block.dart';

enum BattleSquareType {
  empty,
  occupied,
}

extension BattleSquareData on BattleSquareType {
  BattleSquareType getValue(String name) {
    switch (this.name) {
      case "empty":
        return BattleSquareType.empty;
      case "occupied":
        return BattleSquareType.occupied;
      default:
        return BattleSquareType.empty;
    }
  }
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

  factory EmptyBattleSquare.fromJson(Map<String, dynamic> json) {
    return EmptyBattleSquare(
      block: EmptyBlock.fromJson(json['block']),
      type: BattleSquareType.values.byName(json['type']),
      status: BattleSquareStatus.values.byName(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "block": block.toJson(),
      "type": type.name,
      "status": status.name,
    };
  }
}

class OccupiedBattleSquare {
  final OccupiedBlock block;
  final EmptyBlock? targetPoint;
  final num angle;
  final List<EmptyBlock> overlappingPositions;

  OccupiedBattleSquare({
    required this.overlappingPositions,
    required this.angle,
    required this.targetPoint,
    required this.block,
  });

  factory OccupiedBattleSquare.fromJson(Map<String, dynamic> json) {

    final List<EmptyBlock> overlappingPositions = [];

    if (json['overlappingPositions'] != null) {
      json['overlappingPositions'].forEach(
            (b) => overlappingPositions.add(
              EmptyBlock.fromJson(b),
        ),
      );
    }

    return OccupiedBattleSquare(
      block: OccupiedBlock.fromJson(json['block']),
      targetPoint: EmptyBlock.fromJson(json['targetPoint']),
      angle: json['angle'],
      overlappingPositions: overlappingPositions,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      "block": block.toJson(),
      if(targetPoint != null) "targetPoint": targetPoint!.toJson(),
      "angle": angle,
      "overlappingPositions": overlappingPositions.map((e) => e.toJson()).toList(),
    };
  }

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
