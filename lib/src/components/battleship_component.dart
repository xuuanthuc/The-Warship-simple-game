import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:template/src/global/utilities/game_data.dart';
import 'package:template/src/models/battleship.dart';
import 'package:template/src/models/blue_sea.dart';
import 'package:template/src/screens/root/cubit/battleship_control_cubit.dart';
import 'package:template/src/screens/root/root_screen.dart';

class BattleshipComponent extends SpriteComponent
    with
        HasGameRef<MyGame>,
        DragCallbacks,
        TapCallbacks,
        FlameBlocReader<BattleshipControlCubit, BattleshipControlState>,
        FlameBlocListenable<BattleshipControlCubit, BattleshipControlState>,
        CollisionCallbacks {
  final Battleship battleship;
  final int index;

  BattleshipComponent({
    ComponentKey? key,
    required this.battleship,
    required this.index,
  }) : super(key: key);

  late ShapeHitbox _hitBox;

  List<PositionComponent> collisions = [];
  List<BlueSea> overlappingSeaBlocks = [];

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(battleship.sprite);
    anchor = Anchor.center;
    final paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    _hitBox = RectangleHitbox(position: Vector2(5, 5))
      ..paint = paint
      ..renderShape = true;
    scale = Vector2(1, 1);
    size = Vector2(GameData.instance.blockSize * battleship.size,
        GameData.instance.blockSize);
    _hitBox.size = size - Vector2.all(10);
    add(_hitBox);
    return super.onLoad();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final localDelta = event.localDelta;
    final angleMatrix = Matrix2.rotation(angle);
    final localDeltaRotated = angleMatrix.transformed(localDelta);
    position += localDeltaRotated;
    super.onDragUpdate(event);
  }

  @override
  void onDragStart(DragStartEvent event) {
    scale = Vector2(1.1, 1.1);
    priority = 10;
    super.onDragStart(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    scale = Vector2(1, 1);
    priority = 0;
    handlePosition(findClosestVector(GameData.instance.seaBlocks, position));
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
    double halfWidth = (angle == radians(90) ? size.y : size.x) / 2;
    double halfHeight = (angle == radians(90) ? size.x : size.y) / 2;

    // Calculate new position ensuring the entire component stays within the boundary
    double newX = position.x;
    double newY = position.y;

    if (battleship.size % 2 == 0) {
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

  @override
  void onTapUp(TapUpEvent event) async {
    angle = angle == 0 ? radians(90) : 0;
    handlePosition(findClosestVector(GameData.instance.seaBlocks, position));
    super.onTapUp(event);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other.hashCode != this.hashCode) {
      collisions.add(other);
    }
    _hitBox.paint.color = Colors.red.withOpacity(0.5);
    onCollisionCheck();
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (other.hashCode != this.hashCode) {
      collisions.remove(other);
    }
    if (collisions.isEmpty) {
      _hitBox.paint.color = Colors.transparent;
    }
    onCollisionCheck();
    super.onCollisionEnd(other);
  }

  void onCollisionCheck() {
    bloc.checkCollisionBlocks(
      gameRef.world.children.query<BattleshipComponent>(),
    );
  }

  List<BlueSea> getOverlappingSeaBlocks() {
    overlappingSeaBlocks.clear();
    Rect battleshipRect = getBoundingRect();
    for (BlueSea b in GameData.instance.seaBlocks) {
      double minX = b.vector2!.x;
      double maxX = b.vector2!.x;
      double minY = b.vector2!.y;
      double maxY = b.vector2!.y;

      final r = Rect.fromLTRB(minX, minY, maxX, maxY);

      if (battleshipRect.overlaps(r)) {
        overlappingSeaBlocks.add(b);
        print(b.coordinates);
      }
    }
    return overlappingSeaBlocks;
  }

  Rect getBoundingRect() {
    double halfWidth = angle == radians(90) ? size.y / 2 : size.x / 2;
    double halfHeight = angle == radians(90) ? size.x / 2 : size.y / 2;

    Vector2 topLeft = Vector2(-halfWidth, -halfHeight);
    Vector2 topRight = Vector2(halfWidth, -halfHeight);
    Vector2 bottomLeft = Vector2(-halfWidth, halfHeight);
    Vector2 bottomRight = Vector2(halfWidth, halfHeight);

    if (angle == radians(90)) {
      topLeft -= position;
      topRight -= position;
      bottomLeft -= position;
      bottomRight -= position;
    } else {
      topLeft += position;
      topRight += position;
      bottomLeft += position;
      bottomRight += position;
    }
    final boundingRect = angle == radians(90)
        ? Rect.fromLTRB(
            -bottomRight.x, -bottomRight.y, -bottomLeft.x, -topLeft.y)
        : Rect.fromLTRB(topLeft.x, topLeft.y, topRight.x, bottomLeft.y);
    return boundingRect;
  }

  void handlePosition(Vector2 targetPosition) {
    position = adjustPositionToStayWithinBounds(
      targetPosition,
      GameData.instance.getSeaBlocksBoundary(),
      size,
    );
    getOverlappingSeaBlocks();
  }

  @override
  bool listenWhen(
      BattleshipControlState previousState, BattleshipControlState newState) {
    return newState.action == GameAction.prepare;
  }
}
