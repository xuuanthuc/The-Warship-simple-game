import 'dart:async';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:template/src/components/battleship_component.dart';
import 'package:template/src/components/blue_sea_component.dart';
import 'package:template/src/global/utilities/game_data.dart';
import 'package:template/src/screens/root/cubit/battleship_control_cubit.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MyGame(),
    );
  }
}

class MyGame extends FlameGame {
  @override
  Color backgroundColor() {
    return Colors.blue.shade200;
  }

  @override
  FutureOr<void> onLoad() async {
    world = BattleshipWorld();
    add(
      FlameBlocProvider<BattleshipControlCubit, BattleshipControlState>(
        create: () => BattleshipControlCubit(),
        children: [world],
      ),
    );
    return super.onLoad();
  }
}

class BattleshipWorld extends World {
  @override
  FutureOr<void> onLoad() {
    final game = GameData.instance;
    game.seaBlocks.asMap().forEach(
      (yIndex, rowsOfBlocks) {
        rowsOfBlocks.asMap().forEach(
          (xIndex, block) {
            add(
              BlueSeaComponent(
                vector2: Vector2(
                  (xIndex.toDouble() * game.blockSize) -
                      (game.blockSize * GameData.blockLength / 2) + (game.blockSize / 2),
                  (yIndex.toDouble() * game.blockSize) -
                      (game.blockSize * GameData.blockLength / 2) + (game.blockSize / 2),
                ),
              ),
            );
          },
        );
      },
    );
    for (var ship in game.battleships) {
      add(
        BattleshipComponent(
          battleship: ship,
        ),
      );
    }
    return super.onLoad();
  }
}
