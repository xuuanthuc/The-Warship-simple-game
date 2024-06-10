import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:template/src/global/utilities/game_data.dart';
import 'package:template/src/models/battleship.dart';
import 'package:template/src/models/blue_sea.dart';
import 'package:template/src/screens/root/cubit/battleship_control_cubit.dart';

class BattleshipComponent extends SpriteComponent
    with
        DragCallbacks,
        TapCallbacks,
        FlameBlocReader<BattleshipControlCubit, BattleshipControlState>,
        FlameBlocListenable<BattleshipControlCubit, BattleshipControlState> {
  final Battleship battleship;

  BattleshipComponent({required this.battleship});

  @override
  Future<void> onLoad() async {
    sprite = await setBattleshipSprite();
    position = Vector2(200, 100);
    anchor = Anchor.center;
    size = setBattleshipSize();
    return super.onLoad();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
    super.onDragUpdate(event);
  }

  @override
  void onDragStart(DragStartEvent event) {
    scale = Vector2(1.1, 1.1);
    super.onDragStart(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    scale = Vector2(1, 1);
    final v = findClosestVector(GameData.instance.seaBlocks, position);
    position = adjustPositionToStayWithinBounds(
        v, GameData.instance.getSeaBlocksBoundary(), size);
    super.onDragEnd(event);
  }

  Vector2 findClosestVector(List<BlueSea> vectors, Vector2 target) {
    Vector2 closestVector = vectors.first.vector2!;
    double minDistance = double.infinity;

    for (BlueSea vector in vectors) {
      double distance = (vector.vector2! - target).length;
      if (distance < minDistance) {
        minDistance = distance;
        closestVector = vector.vector2!;
      }
    }
    return closestVector;
  }

  Vector2 adjustPositionToStayWithinBounds(
      Vector2 position, Rect boundary, Vector2 size) {
    double halfWidth = size.x / 2;
    double halfHeight = size.y / 2;

    // Calculate new position ensuring the entire component stays within the boundary
    double newX = position.x;
    double newY = position.y;

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

  @override
  void onTapUp(TapUpEvent event) async {
    battleship.symmetric =
        battleship.symmetric == BattleshipSymmetric.horizontal
            ? BattleshipSymmetric.vertical
            : BattleshipSymmetric.horizontal;
    size = setBattleshipSize();
    sprite = await setBattleshipSprite();
    position = adjustPositionToStayWithinBounds(
        position, GameData.instance.getSeaBlocksBoundary(), size);
    super.onTapUp(event);
  }

  Future<Sprite> setBattleshipSprite() async {
    return await Sprite.load(
      battleship.symmetric == BattleshipSymmetric.horizontal
          ? battleship.horizontalSprite
          : battleship.verticalSprite,
    );
  }

  Vector2 setBattleshipSize() {
    return battleship.symmetric == BattleshipSymmetric.horizontal
        ? Vector2(GameData.instance.blockSize * battleship.size,
            GameData.instance.blockSize)
        : Vector2(GameData.instance.blockSize,
            GameData.instance.blockSize * battleship.size);
  }
}
