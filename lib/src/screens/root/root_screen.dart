import 'dart:async';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:template/src/components/battleship_component.dart';
import 'package:template/src/components/blue_sea_component.dart';
import 'package:template/src/global/utilities/game_data.dart';
import 'package:template/src/screens/root/cubit/battleship_control_cubit.dart';
import '../../models/blue_sea.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MyGame(),
    );
  }
}

class MyGame extends FlameGame with HasCollisionDetection {
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

    game.setSeaBlocks();
    for (var i = 0; i < game.seaBlocks.length; i++) {
      add(
        BlueSeaComponent(
          blueSea: game.seaBlocks[i],
          index: i,
        ),
      );
    }

    for (var i = 0; i < game.battleships.length; i++) {
      add(
        BattleshipComponent(
          battleship: game.battleships[i],
          index: i,
        ),
      );
    }
    return super.onLoad();
  }
}
