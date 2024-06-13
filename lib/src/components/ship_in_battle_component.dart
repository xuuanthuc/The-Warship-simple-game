import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:template/src/global/utilities/game_data.dart';
import 'package:template/src/models/battle.dart';
import 'package:template/src/models/battleship.dart';
import 'package:template/src/models/blue_sea.dart';
import 'package:template/src/screens/root/cubit/battleship_control_cubit.dart';

class ShipInBattleComponent extends SpriteComponent
    with
        FlameBlocReader<BattleshipControlCubit, BattleshipControlState>,
        FlameBlocListenable<BattleshipControlCubit, BattleshipControlState>, HasVisibility {
  final ShipInBattle shipInBattle;
  final int index;
  final Vector2 positionInit;
  final double angleInit;

  ShipInBattleComponent({
    ComponentKey? key,
    required this.shipInBattle,
    required this.index,
    required this.positionInit,
    required this.angleInit,
  }) : super(key: key);

  List<PositionComponent> collisions = [];
  List<BlueSea> overlappingSeaBlocks = [];

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(shipInBattle.ship.sprite);
    anchor = Anchor.center;
    angle = angleInit;
    priority = 3;
    isVisible = false;
    Future.delayed(Duration(seconds: 1)).then((_) {
      handlePosition(findClosestVector(bloc.state.battles, positionInit));
    });
    size = Vector2(GameData.instance.blockSize * shipInBattle.ship.size,
        GameData.instance.blockSize);
    return super.onLoad();
  }


  Vector2 findClosestVector(List<SeaInBattle> vectors, Vector2 target) {
    Vector2 closestVector = vectors.first.blueSea.vector2!;
    double minDistance = double.infinity;

    for (SeaInBattle vector in vectors) {
      double distance = (vector.blueSea.vector2! - target).length;
      if (distance < minDistance) {
        minDistance = distance;
        closestVector = vector.blueSea.vector2!;
      }
    }
    return closestVector;
  }

  Vector2 adjustPositionToStayWithinBounds(
      Vector2 position, Rect boundary, Vector2 size) {
    double halfWidth = (angle == radians(90) ? size.y : size.x) / 2;
    double halfHeight = (angle == radians(90) ? size.x : size.y) / 2;

    // Calculate new position ensuring the entire component stays within the boundary
    double newX = position.x;
    double newY = position.y;

    if (shipInBattle.ship.size % 2 == 0) {
      if (angle == radians(90)) {
        newY += GameData.instance.blockSize / 2;
      } else {
        newX += GameData.instance.blockSize / 2;
      }
    }

    // Ensure the component doesn't go beyond the left or right boundaries
    if (newX - halfWidth < boundary.left) {
      newX = boundary.left + halfWidth;
    } else if (newX + halfWidth > boundary.right) {
      newX = boundary.right - halfWidth;
    }

    // Ensure the component doesn't go beyond the top or bottom boundaries
    if (newY - halfHeight < boundary.top) {
      newY = boundary.top + halfHeight;
    } else if (newY + halfHeight > boundary.bottom) {
      newY = boundary.bottom - halfHeight;
    }
    return Vector2(newX, newY);
  }

  void handlePosition(Vector2 targetPosition) {
    position = adjustPositionToStayWithinBounds(
      targetPosition,
      GameData.instance.getSeaBlocksBoundary(),
      size,
    );
  }

  @override
  void onNewState(BattleshipControlState state) {
    print('check state');
    if(shipInBattle.positions.isEmpty){
      isVisible = true;
    }
    super.onNewState(state);
  }
}
