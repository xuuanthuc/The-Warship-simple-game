import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:template/src/global/style/app_images.dart';
import 'package:template/src/models/blue_sea.dart';

import '../../models/battleship.dart';

enum GameStatus {
  init,
  loading,
  loaded,
  preparing,
  prepared,
  ready,
  started,
  playing,
  paused,
  resumed,
  finished,
  error,
}

class GameData {
  GameData._privateConstructor();

  static final GameData _instance = GameData._privateConstructor();

  static GameData get instance => _instance;

  static const blockLength = 10;

  Size get screenSize =>
      WidgetsBinding.instance.platformDispatcher.views.first.physicalSize / 2;

  double get blockSize => screenSize.width < screenSize.height
      ? screenSize.width / 12
      : screenSize.height / 12;

  List<Battleship> battleships = [
    Battleship(
      sprite: AppImages.tinyShipA,
      size: 2,
      id: 001,
    ),
    Battleship(
      sprite: AppImages.smallShipA,
      size: 3,
      id: 002,
    ),
    Battleship(
      sprite: AppImages.smallShipA,
      size: 3,
      id: 003,
    ),
    Battleship(
      sprite: AppImages.mediumShipA,
      size: 4,
      id: 004,
    ),
    Battleship(
      sprite: AppImages.largeShipA,
      size: 5,
      id: 005,
    ),
  ];

  List<Battleship> enemyBattleships = [
    Battleship(
      sprite: AppImages.tinyShipB,
      size: 2,
      id: 001,
    ),
    Battleship(
      sprite: AppImages.smallShipB,
      size: 3,
      id: 002,
    ),
    Battleship(
      sprite: AppImages.smallShipB,
      size: 3,
      id: 003,
    ),
    Battleship(
      sprite: AppImages.mediumShipB,
      size: 4,
      id: 004,
    ),
    Battleship(
      sprite: AppImages.largeShipB,
      size: 5,
      id: 005,
    ),
  ];

  List<List<BlueSea>> blueBlocks = List.generate(
    blockLength,
    (index) => List.generate(
      blockLength,
      (index) {
        return BlueSea();
      },
    ),
  );

  List<BlueSea> seaBlocks = [];

  List<BlueSea> setSeaBlocks() {
    seaBlocks.clear();
    blueBlocks.asMap().forEach(
      (yIndex, rowsOfBlocks) {
        rowsOfBlocks.asMap().forEach(
          (xIndex, block) {
            block.vector2 = Vector2(
              (xIndex.toDouble() * blockSize) -
                  (blockSize * GameData.blockLength / 2) +
                  (blockSize / 2),
              (yIndex.toDouble() * blockSize) -
                  (blockSize * GameData.blockLength / 2) +
                  (blockSize / 2),
            );
            block.coordinates = [yIndex, xIndex];
            seaBlocks.add(block);
          },
        );
      },
    );
    return seaBlocks;
  }

  Vector2 setBlockVector2(int xIndex, int yIndex) {
    return Vector2(
      (xIndex.toDouble() * blockSize) -
          (blockSize * GameData.blockLength / 2) +
          (blockSize / 2),
      (yIndex.toDouble() * blockSize) -
          (blockSize * GameData.blockLength / 2) +
          (blockSize / 2),
    );
  }

  // New method to get the boundaries
  Rect getSeaBlocksBoundary() {
    if (seaBlocks.isEmpty) return Rect.zero;

    double minX = seaBlocks.first.vector2!.x;
    double maxX = seaBlocks.first.vector2!.x;
    double minY = seaBlocks.first.vector2!.y;
    double maxY = seaBlocks.first.vector2!.y;

    for (var block in seaBlocks) {
      if (block.vector2!.x < minX) minX = block.vector2!.x;
      if (block.vector2!.x > maxX) maxX = block.vector2!.x;
      if (block.vector2!.y < minY) minY = block.vector2!.y;
      if (block.vector2!.y > maxY) maxY = block.vector2!.y;
    }

    return Rect.fromLTRB(minX - blockSize / 2, minY - blockSize / 2,
        maxX + blockSize / 2, maxY + blockSize / 2);
  }
}
