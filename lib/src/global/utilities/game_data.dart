import 'package:flutter/cupertino.dart';
import 'package:template/src/global/style/app_images.dart';
import 'package:template/src/models/blue_sea.dart';

import '../../models/battleship.dart';

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
      horizontalSprite: AppImages.smallHorizontalShip,
      verticalSprite: AppImages.smallVerticalShip,
      size: 3,
      symmetric: BattleshipSymmetric.horizontal,
    ),
    Battleship(
      horizontalSprite: AppImages.smallHorizontalShip,
      verticalSprite: AppImages.smallVerticalShip,
      size: 3,
      symmetric: BattleshipSymmetric.horizontal,
    ),
    Battleship(
      horizontalSprite: AppImages.mediumHorizontalShip,
      verticalSprite: AppImages.mediumVerticalShip,
      size: 4,
      symmetric: BattleshipSymmetric.horizontal,
    ),
  ];

  List<List<BlueSea>> seaBlocks = List.generate(
    blockLength,
    (index) => List.generate(
      blockLength,
      (index) {
        return BlueSea();
      },
    ),
  );
}
