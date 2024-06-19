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
  final ready = ReadyBattleWorld();
  late OpponentBattleWorld _opponent;
  late OwnerBattleWorld _owner;

  @override
  Future<void> onLoad() async {
    await add(TerrainComponent());
    await add(ready);
    return super.onLoad();
  }


  @override
  void onNewState(GamePlayState state) async {
    print("Game plat world changed state");
    if (state.action == GameAction.ready) {
      if (ready.isLoaded) {
        remove(ready);
      }
      _opponent = OpponentBattleWorld(
        emptySquares: bloc.state.room.opponentPlayingData?.emptyBlocks ?? [],
        occupiedSquares:
            bloc.state.room.opponentPlayingData?.occupiedBlocks ?? [],
      );
      _owner = OwnerBattleWorld(
        emptySquares: bloc.state.room.ownerPlayingData?.emptyBlocks ?? [],
        occupiedSquares: bloc.state.room.ownerPlayingData?.occupiedBlocks ?? [],
      );
      bloc.startGame();
    }
    if (state.action == GameAction.nextTurn) {
      if (state.room.nextPlayer?.id == state.room.ownerPlayer?.id) {
        await add(_opponent);
        if(_owner.isLoaded) {
          remove(_owner);
        }
      } else {
        await add(_owner);
        if(_opponent.isLoaded){
          remove(_opponent);
        }
      }
    }
    super.onNewState(state);
  }

  @override
  bool listenWhen(
    GamePlayState previousState,
    GamePlayState newState,
  ) {
    return newState.action == GameAction.nextTurn ||
        newState.action == GameAction.ready;
  }
}

class OpponentBattleWorld extends PositionComponent
    with FlameBlocListenable<GamePlayCubit, GamePlayState> {
  final List<EmptyBattleSquare> emptySquares;
  final List<OccupiedBattleSquare> occupiedSquares;

  OpponentBattleWorld({
    required this.emptySquares,
    required this.occupiedSquares,
  });

  @override
  FutureOr<void> onLoad() async {
    size = Vector2.all(GameData.instance.blockSize * GameData.blockLength);
    for (var i = 0; i < emptySquares.length; i++) {
      EmptyBattleSquare block = emptySquares[i];
      block.block.vector2 = GameData.instance.setBlockVector2(
        block.block.coordinates!.last,
        block.block.coordinates!.first,
      );
      await add(
        EmptyBattleSquareComponent(
          battle: emptySquares[i],
        ),
      );
    }
    for (var i = 0; i < occupiedSquares.length; i++) {
      final ship = occupiedSquares[i];
      await add(
        OccupiedBattleSquareComponent(
          key: ComponentKey.unique(),
          square: ship,
          index: i,
          isOpponent: true,
          initialAngle: ship.angle,
          initialPosition: GameData.instance.setBlockVector2(
            ship.targetPoint!.coordinates!.last,
            ship.targetPoint!.coordinates!.first,
          ),
        ),
      );
    }
    return super.onLoad();
  }
}

class OwnerBattleWorld extends PositionComponent
    with FlameBlocListenable<GamePlayCubit, GamePlayState> {
  final List<EmptyBattleSquare> emptySquares;
  final List<OccupiedBattleSquare> occupiedSquares;

  OwnerBattleWorld({
    required this.emptySquares,
    required this.occupiedSquares,
  });

  @override
  FutureOr<void> onLoad() async {
    size = Vector2.all(GameData.instance.blockSize * GameData.blockLength);
    for (var i = 0; i < emptySquares.length; i++) {
      EmptyBattleSquare block = emptySquares[i];
      block.block.vector2 = GameData.instance.setBlockVector2(
        block.block.coordinates!.last,
        block.block.coordinates!.first,
      );
      await add(
        EmptyBattleSquareComponent(
          battle: emptySquares[i],
        ),
      );
    }
    for (var i = 0; i < occupiedSquares.length; i++) {
      final ship = occupiedSquares[i];
      await add(
        OccupiedBattleSquareComponent(
          key: ComponentKey.unique(),
          square: ship,
          index: i,
          initialAngle: ship.angle,
          isOpponent: false,
          initialPosition: GameData.instance.setBlockVector2(
            ship.targetPoint!.coordinates!.last,
            ship.targetPoint!.coordinates!.first,
          ),
        ),
      );
    }
    return super.onLoad();
  }
}

class ReadyBattleWorld extends PositionComponent
    with
        FlameBlocReader<GamePlayCubit, GamePlayState>,
        FlameBlocListenable<GamePlayCubit, GamePlayState> {
  @override
  Future<void> onLoad() async {
    final game = GameData.instance;
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
}
