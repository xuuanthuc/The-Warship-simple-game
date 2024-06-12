import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:template/src/components/battle_component.dart';
import 'package:template/src/components/battleship_component.dart';
import 'package:template/src/components/blue_sea_component.dart';
import 'package:template/src/di/dependencies.dart';
import 'package:template/src/global/utilities/game_data.dart';
import 'package:template/src/screens/root/cubit/battleship_control_cubit.dart';
import '../../components/ready_button_component.dart';
import '../../models/battle.dart';

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
        create: () => getIt.get<BattleshipControlCubit>(),
        children: [
          world,
        ],
      ),
    );
    return super.onLoad();
  }
}

class BattleshipWorld extends World
    with
        FlameBlocReader<BattleshipControlCubit, BattleshipControlState>,
        FlameBlocListenable<BattleshipControlCubit, BattleshipControlState> {
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
        ),
      );
    }
    Future.delayed(Duration(seconds: 2)).then((onValue) {
      bloc.shuffleShipPosition(children.query<BattleshipComponent>());
    });
    await add(ReadyButtonComponent());
    return super.onLoad();
  }

  @override
  void onNewState(BattleshipControlState state) async {
    for (var i = 0; i < state.battles.length; i++) {
      Battle block = state.battles[i];
      block.blueSea.vector2 = GameData.instance.setBlockVector2(
        block.blueSea.coordinates!.last,
        block.blueSea.coordinates!.first,
      );
      await add(
        BattleComponent(
          battle: state.battles[i],
        ),
      );
    }
    super.onNewState(state);
  }

  @override
  bool listenWhen(
    BattleshipControlState previousState,
    BattleshipControlState newState,
  ) {
    return newState.action == GameAction.ready;
  }
}
