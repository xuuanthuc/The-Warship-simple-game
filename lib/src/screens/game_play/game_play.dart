import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/components/how_to_setting_component.dart';
import 'package:template/src/components/occupied_component.dart';
import 'package:template/src/components/empty_square_component.dart';
import 'package:template/src/models/player.dart';
import 'package:template/src/models/room_data.dart';
import 'package:template/src/routes/route_keys.dart';
import 'package:template/src/screens/game_play/widget/game_exit.dart';
import 'package:template/src/screens/game_play/widget/game_over.dart';
import 'package:template/src/screens/game_play/widget/game_turn_intro.dart';
import 'package:template/src/style/app_audio.dart';
import 'package:template/src/screens/game_play/widget/ready_button.dart';
import 'package:template/src/style/app_colors.dart';
import 'package:template/src/utilities/game_data.dart';
import '../../bloc/game_play/game_play_cubit.dart';
import '../../components/battle_component.dart';
import '../../components/parallax_background_component.dart';
import '../../components/terrain_component.dart';
import '../../components/turn_info_component.dart';

class GamePlayScreen extends StatefulWidget {
  final RoomData room;
  final Player player;

  const GamePlayScreen({
    Key? key,
    required this.room,
    required this.player,
  }) : super(key: key);

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  @override
  void initState() {
    FlameAudio.bgm.play(AppAudio.gamePlay, volume: 0.5);
    context.read<GamePlayCubit>().getRoomDataToPrepareBattleGame(
          widget.room,
          widget.player,
        );
    game = BattleGameFlame(
      cubit: context.read<GamePlayCubit>(),
    );
    super.initState();
  }

  late final BattleGameFlame game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: game,
        overlayBuilderMap: {
          RouteKey.gameOver: (_, BattleGameFlame game) {
            return const GameOverOverlay();
          },
          RouteKey.gameExit: (_, BattleGameFlame game) {
            return const GameExitButton();
          },
          RouteKey.readyButton: (_, BattleGameFlame game) {
            return GameReadyButton(game: game);
          },
          RouteKey.yourTurn: (_, BattleGameFlame game) {
            return TurnIntro(
              game: game,
              isOpponent: false,
            );
          },
          RouteKey.opponentTurn: (_, BattleGameFlame game) {
            return TurnIntro(
              game: game,
              isOpponent: true,
            );
          }
        },
        backgroundBuilder: (context) =>
            BlocBuilder<GamePlayCubit, GamePlayState>(
          buildWhen: (_, cur) => cur.action == GameAction.nextTurn,
          builder: (context, state) {
            return AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
              decoration: BoxDecoration(
                gradient: state.room.nextPlayer?.skin?.background() ??
                    AppColors.backgroundBlue,
              ),
            );
          },
        ),
      ),
    );
  }
}

class BattleGameFlame extends FlameGame with HasCollisionDetection {
  final GamePlayCubit cubit;

  BattleGameFlame({required this.cubit});

  @override
  Color backgroundColor() {
    return Colors.blue;
  }

  @override
  FutureOr<void> onLoad() async {
    final parallax = MyParallaxComponent();
    world = BattlegroundWorld();
    await add(
      FlameBlocProvider<GamePlayCubit, GamePlayState>.value(
        value: cubit,
        children: [
          parallax,
          world,
        ],
      ),
    );
    overlays.add(RouteKey.gameExit);
    overlays.add(RouteKey.readyButton);
    return super.onLoad();
  }
}

class BattlegroundWorld extends World
    with
        HasGameRef<BattleGameFlame>,
        FlameBlocReader<GamePlayCubit, GamePlayState>,
        FlameBlocListenable<GamePlayCubit, GamePlayState> {
  final ready = ReadyBattleWorld();
  late GuestBattleWorld _guest;
  late OwnerBattleWorld _owner;

  @override
  Future<void> onLoad() async {
    await add(TerrainComponent());
    await add(ready);
    return super.onLoad();
  }

  @override
  void onNewState(GamePlayState state) async {
    if (state.action == GameAction.ready) {
      if (ready.isLoaded && ready.isMounted) {
        remove(ready);
      }
      _guest = GuestBattleWorld(
        emptySquares: bloc.state.room.guestPlayingData?.emptyBlocks ?? [],
        occupiedSquares: bloc.state.room.guestPlayingData?.occupiedBlocks ?? [],
      );
      _owner = OwnerBattleWorld(
        emptySquares: bloc.state.room.ownerPlayingData?.emptyBlocks ?? [],
        occupiedSquares: bloc.state.room.ownerPlayingData?.occupiedBlocks ?? [],
      );
      await add(TurnInfoComponent());
      await Future.delayed(const Duration(seconds: 2)).then((_) => bloc.startGame());
    }
    if (state.action == GameAction.nextTurn) {
      if (state.room.nextPlayer?.id == state.room.ownerPlayer?.id) {
        await add(_guest);
        if (_owner.isLoaded && !_owner.isRemoved) {
          remove(_owner);
        }
      } else {
        await add(_owner);
        if (_guest.isLoaded && !_guest.isRemoved) {
          remove(_guest);
        }
      }
    }
    if (state.action == GameAction.end) {
      gameRef.overlays.add(RouteKey.gameOver);
    }
    super.onNewState(state);
  }

  @override
  bool listenWhen(
    GamePlayState previousState,
    GamePlayState newState,
  ) {
    return newState.action == GameAction.nextTurn ||
        newState.action == GameAction.ready ||
        newState.action == GameAction.end;
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
    await add(HowToSettingComponent());
    Future.delayed(const Duration(milliseconds: 300)).then((onValue) {
      bloc.shuffleOccupiedPosition(children.query<OccupiedComponent>());
    });
    return super.onLoad();
  }
}
