import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:template/src/bloc/game_play/game_play_cubit.dart';
import 'package:template/src/utilities/game_data.dart';
import 'package:template/src/models/occupied_block.dart';
import 'package:template/src/models/empty_block.dart';

import '../screens/game_play/game_play.dart';

class OccupiedComponent extends SpriteComponent
    with
        HasGameRef<BattleGameFlame>,
        DragCallbacks,
        TapCallbacks,
        FlameBlocReader<GamePlayCubit, GamePlayState>,
        FlameBlocListenable<GamePlayCubit, GamePlayState>,
        CollisionCallbacks {
  final OccupiedBlock block;
  final int index;
  EmptyBlock? targetPoint;

  OccupiedComponent({
    ComponentKey? key,
    required this.block,
    required this.index,
  }) : super(key: key);

  late ShapeHitbox _hitBox;

  List<PositionComponent> collisions = [];
  List<EmptyBlock> overlappingEmptyBlocks = [];

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(block.sprite);
    anchor = Anchor.center;
    final paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;
    _hitBox = RectangleHitbox(position: Vector2(5, 5))
      ..paint = paint
      ..renderShape = true;
    scale = Vector2(1, 1);
    priority = 0;
    size = Vector2(
        GameData.instance.blockSize * block.size, GameData.instance.blockSize);
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
    handlePosition(findClosestVector(GameData.instance.emptyBlocks, position));
    super.onDragEnd(event);
  }

  Vector2 findClosestVector(List<EmptyBlock> vectors, Vector2 target) {
    Vector2 closestVector = vectors.first.vector2 ?? Vector2.zero();
    double minDistance = double.infinity;

    for (EmptyBlock vector in vectors) {
      double distance = ((vector.vector2 ?? Vector2.zero()) - target).length;
      if (distance < minDistance) {
        minDistance = distance;
        closestVector = vector.vector2 ?? Vector2.zero();
        targetPoint = vector;
      }
    }
    return closestVector;
  }

  Vector2 adjustPositionToStayWithinBounds(
      Vector2 position, Rect boundary, Vector2 size) {
    double halfWidth = (angle == 0 ? size.x : size.y) / 2;
    double halfHeight = (angle == 0 ? size.y : size.x) / 2;

    // Calculate new position ensuring the entire component stays within the boundary
    double newX = position.x;
    double newY = position.y;

    if (block.size % 2 == 0) {
      if (angle == 0) {
        newX += GameData.instance.blockSize / 2;
      } else {
        newY += GameData.instance.blockSize / 2;
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
    handlePosition(findClosestVector(GameData.instance.emptyBlocks, position));
    super.onTapUp(event);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is OccupiedComponent) {
      if (other.hashCode != this.hashCode) {
        collisions.add(other);
      }
      _hitBox.paint.color = Colors.red.withOpacity(0.5);
      onCollisionCheck();
    }
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
      gameRef.world.children
          .query<ReadyBattleWorld>()
          .first
          .children
          .query<OccupiedComponent>(),
    );
  }

  List<EmptyBlock> getOverlappingSeaBlocks() {
    overlappingEmptyBlocks.clear();
    Rect battleshipRect = getBoundingRect();
    for (EmptyBlock b in GameData.instance.emptyBlocks) {
      double minX = b.vector2!.x;
      double maxX = b.vector2!.x;
      double minY = b.vector2!.y;
      double maxY = b.vector2!.y;

      final r = Rect.fromLTRB(minX, minY, maxX, maxY);

      if (battleshipRect.overlaps(r)) {
        overlappingEmptyBlocks.add(b);
      }
    }
    return overlappingEmptyBlocks;
  }

  Rect getBoundingRect() {
    double halfWidth = angle == 0 ? size.x / 2 : size.y / 2;
    double halfHeight = angle == 0 ? size.y / 2 : size.x / 2;

    Vector2 topLeft = Vector2(-halfWidth, -halfHeight);
    Vector2 topRight = Vector2(halfWidth, -halfHeight);
    Vector2 bottomLeft = Vector2(-halfWidth, halfHeight);
    Vector2 bottomRight = Vector2(halfWidth, halfHeight);

    if (angle == 0) {
      topLeft += position;
      topRight += position;
      bottomLeft += position;
      bottomRight += position;
    } else {
      topLeft -= position;
      topRight -= position;
      bottomLeft -= position;
      bottomRight -= position;
    }
    final boundingRect = angle == 0
        ? Rect.fromLTRB(topLeft.x, topLeft.y, topRight.x, bottomLeft.y)
        : Rect.fromLTRB(
            -bottomRight.x, -bottomRight.y, -bottomLeft.x, -topLeft.y);
    return boundingRect;
  }

  void handlePosition(Vector2 targetPosition) {
    position = adjustPositionToStayWithinBounds(
      targetPosition,
      GameData.instance.getEmptyBlocksBoundary(),
      size,
    );
    getOverlappingSeaBlocks();
  }

  @override
  bool listenWhen(GamePlayState previousState, GamePlayState newState) {
    return newState.action == GameAction.prepare;
  }
}
