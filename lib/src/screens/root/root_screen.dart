import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/components/sea_battle_component.dart';
import 'package:template/src/components/battleship_component.dart';
import 'package:template/src/components/blue_sea_component.dart';
import 'package:template/src/components/ship_in_battle_component.dart';
import 'package:template/src/global/utilities/game_data.dart';
import 'package:template/src/screens/root/cubit/battleship_control_cubit.dart';
import '../../components/ocean_component.dart';
import '../../components/parallax_background_component.dart';
import '../../components/ready_button_component.dart';
import '../../models/battle.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BattleshipControlCubit>().printInstance();
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: MyGame(
        cubit: context.read<BattleshipControlCubit>(),
      ),
    );
  }
}

class MyGame extends FlameGame with HasCollisionDetection {
  final BattleshipControlCubit cubit;

  MyGame({required this.cubit});

  @override
  Color backgroundColor() {
    return Colors.blue.shade200;
  }

  @override
  FutureOr<void> onLoad() async {
    final parallax = MyParallaxComponent();
    world = BattleshipWorld();
    await add(
      FlameBlocProvider<BattleshipControlCubit, BattleshipControlState>.value(
        value: cubit,
        children: [
          world,
          parallax,
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
    add(OceanSprite());
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
    await add(ReadyButtonComponent());
    Future.delayed(Duration(milliseconds: 300)).then((onValue) {
      bloc.printInstance();
      bloc.shuffleShipPosition(children.query<BattleshipComponent>());
    });
    return super.onLoad();
  }

  @override
  void onNewState(BattleshipControlState state) async {
    for (var i = 0; i < state.battles.length; i++) {
      SeaInBattle block = state.battles[i];
      block.blueSea.vector2 = GameData.instance.setBlockVector2(
        block.blueSea.coordinates!.last,
        block.blueSea.coordinates!.first,
      );
      await add(
        SeaInBattleComponent(
          battle: state.battles[i],
        ),
      );
    }
    // children.query()

    for (var i = 0; i < state.ships.length; i++) {
      final ship = state.ships[i];
      await add(
        ShipInBattleComponent(
          key: ComponentKey.unique(),
          shipInBattle: ship,
          index: i,
          angleInit: ship.angle,
          positionInit: GameData.instance.setBlockVector2(
            ship.centerPoint!.coordinates!.last,
            ship.centerPoint!.coordinates!.first,
          ),
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
