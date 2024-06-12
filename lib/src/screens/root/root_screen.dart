import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:template/src/components/battleship_component.dart';
import 'package:template/src/components/blue_sea_component.dart';
import 'package:template/src/global/utilities/game_data.dart';
import 'package:template/src/screens/root/cubit/battleship_control_cubit.dart';
import '../../components/ready_button_component.dart';
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
    await add(
      FlameBlocProvider<BattleshipControlCubit, BattleshipControlState>(
        create: () => BattleshipControlCubit(),
        children: [
          world,
          ReadyButtonComponent(),
        ],
      ),
    );
    return super.onLoad();
  }
}

class BattleshipWorld extends World
    with FlameBlocReader<BattleshipControlCubit, BattleshipControlState> {
  @override
  Future<void> onLoad() async {
    final game = GameData.instance;

    game.setSeaBlocks();
    for (var i = 0; i < game.seaBlocks.length; i++) {
      await add(
        BlueSeaComponent(
          blueSea: game.seaBlocks[i],
          index: i,
        ),
      );
    }
    for (var i = 0; i < game.battleships.length; i++) {
      await add(
        BattleshipComponent(
          key: ComponentKey.unique(),
          battleship: game.battleships[i],
          index: i,
          onCollisionCheck: () {
            bloc.checkCollisionBlocks(children.query<BattleshipComponent>());
          },
        ),
      );
    }
    Future.delayed(Duration(seconds: 2)).then((onValue){
      bloc.shuffleShipPosition(children.query<BattleshipComponent>());
    });
    return super.onLoad();
  }
}
