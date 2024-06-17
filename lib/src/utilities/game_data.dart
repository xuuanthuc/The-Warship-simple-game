import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:template/src/style/app_images.dart';
import 'package:template/src/models/empty_block.dart';
import '../models/occupied_block.dart';

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

enum BattleshipSkin { A, B }

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

  List<OccupiedBlock> battleOccupied = [
    OccupiedBlock(
      sprite: AppImages.tinyShipA,
      size: 2,
      id: 001,
    ),
    OccupiedBlock(
      sprite: AppImages.smallShipA,
      size: 3,
      id: 002,
    ),
    OccupiedBlock(
      sprite: AppImages.smallShipA,
      size: 3,
      id: 003,
    ),
    OccupiedBlock(
      sprite: AppImages.mediumShipA,
      size: 4,
      id: 004,
    ),
    OccupiedBlock(
      sprite: AppImages.largeShipA,
      size: 5,
      id: 005,
    ),
  ];

  List<List<EmptyBlock>> matrixEmptyBlocks = List.generate(
    blockLength,
    (index) => List.generate(
      blockLength,
      (index) {
        return EmptyBlock();
      },
    ),
  );

  List<EmptyBlock> emptyBlocks = [];

  List<EmptyBlock> setSeaBlocks() {
    emptyBlocks.clear();
    matrixEmptyBlocks.asMap().forEach(
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
            emptyBlocks.add(block);
          },
        );
      },
    );
    return emptyBlocks;
  }

  void setOccupiedSkin(BattleshipSkin skin) {
    for (OccupiedBlock block in battleOccupied) {
      switch (skin) {
        case BattleshipSkin.A:
          switch (block.size) {
            case 2:
              block.sprite = AppImages.tinyShipA;
              break;
            case 3:
              block.sprite = AppImages.smallShipA;
              break;
            case 4:
              block.sprite = AppImages.mediumShipA;
              break;
            case 5:
              block.sprite = AppImages.largeShipA;
              break;
          }
          break;
        case BattleshipSkin.B:
          switch (block.size) {
            case 2:
              block.sprite = AppImages.tinyShipB;
              break;
            case 3:
              block.sprite = AppImages.smallShipB;
              break;
            case 4:
              block.sprite = AppImages.mediumShipB;
              break;
            case 5:
              block.sprite = AppImages.largeShipB;
              break;
          }
          break;
      }
    }
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
  Rect getEmptyBlocksBoundary() {
    if (emptyBlocks.isEmpty) return Rect.zero;

    double minX = emptyBlocks.first.vector2!.x;
    double maxX = emptyBlocks.first.vector2!.x;
    double minY = emptyBlocks.first.vector2!.y;
    double maxY = emptyBlocks.first.vector2!.y;

    for (var block in emptyBlocks) {
      if (block.vector2!.x < minX) minX = block.vector2!.x;
      if (block.vector2!.x > maxX) maxX = block.vector2!.x;
      if (block.vector2!.y < minY) minY = block.vector2!.y;
      if (block.vector2!.y > maxY) maxY = block.vector2!.y;
    }

    return Rect.fromLTRB(minX - blockSize / 2, minY - blockSize / 2,
        maxX + blockSize / 2, maxY + blockSize / 2);
  }
}
