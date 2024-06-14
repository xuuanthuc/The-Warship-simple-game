import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/components/empty_battle_square_component.dart';
import 'package:template/src/components/occupied_component.dart';
import 'package:template/src/components/empty_square_component.dart';
import 'package:template/src/components/occupied_battle_square_component.dart';
import 'package:template/src/utilities/game_data.dart';
import '../../bloc/game_play/game_play_cubit.dart';
import '../../components/terrain_component.dart';
import '../../components/parallax_background_component.dart';
import '../../components/ready_button_component.dart';
import '../../models/battle.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({Key? key}) : super(key: key);

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  @override

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: BattleGameFlame(
        cubit: context.read<GamePlayCubit>(),
      ),
    );
  }
}

class BattleGameFlame extends FlameGame with HasCollisionDetection {
  final GamePlayCubit cubit;

  BattleGameFlame({required this.cubit});

  @override
  Color backgroundColor() {
    return Colors.blue.shade200;
  }

  @override
  FutureOr<void> onLoad() async {
    final parallax = MyParallaxComponent();
    world = BattlegroundWorld();
    await add(
      FlameBlocProvider<GamePlayCubit, GamePlayState>.value(
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

class BattlegroundWorld extends World
    with
        FlameBlocReader<GamePlayCubit, GamePlayState>,
        FlameBlocListenable<GamePlayCubit, GamePlayState> {
  @override
  Future<void> onLoad() async {
    final game = GameData.instance;
    add(TerrainComponent());
    game.setSeaBlocks();
    for (var i = 0; i < game.emptyBlocks.length; i++) {
      await add(
        EmptySquareComponent(
          blueSea: game.emptyBlocks[i],
          index: i,
        ),
      );
    }
    for (var i = 0; i < game.battleOccupied.length; i++) {
      await add(
        OccupiedComponent(
          key: ComponentKey.unique(),
          block: game.battleOccupied[i],
          index: i,
        ),
      );
    }
    await add(ReadyButtonComponent());
    Future.delayed(Duration(milliseconds: 300)).then((onValue) {
      bloc.shuffleOccupiedPosition(children.query<OccupiedComponent>());
    });
    return super.onLoad();
  }

  @override
  void onNewState(GamePlayState state) async {
    for (var i = 0; i < state.emptySquares.length; i++) {
      EmptyBattleSquare block = state.emptySquares[i];
      block.block.vector2 = GameData.instance.setBlockVector2(
        block.block.coordinates!.last,
        block.block.coordinates!.first,
      );
      await add(
        EmptyBattleSquareComponent(
          battle: state.emptySquares[i],
        ),
      );
    }
    // children.query()

    for (var i = 0; i < state.occupiedSquares.length; i++) {
      final ship = state.occupiedSquares[i];
      await add(
        OccupiedBattleSquareComponent(
          key: ComponentKey.unique(),
          square: ship,
          index: i,
          initialAngle: ship.angle,
          initialPosition: GameData.instance.setBlockVector2(
            ship.targetPoint!.coordinates!.last,
            ship.targetPoint!.coordinates!.first,
          ),
        ),
      );
    }

    super.onNewState(state);
  }

  @override
  bool listenWhen(
    GamePlayState previousState,
    GamePlayState newState,
  ) {
    return newState.action == GameAction.ready;
  }
}
