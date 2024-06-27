import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:template/src/screens/game_play/game_play.dart';
import '../bloc/game_play/game_play_cubit.dart';
import '../routes/route_keys.dart';

class TurnInfoComponent extends TextComponent
    with
        HasGameRef<BattleGameFlame>,
        FlameBlocListenable<GamePlayCubit, GamePlayState> {
  final TextComponent _playerTurn = TextComponent(
    text: '',
    textRenderer: TextPaint(
      style: const TextStyle(
        fontFamily: "Mitr",
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    priority = 10;
    add(_playerTurn);
    return super.onLoad();
  }

  @override
  void onNewState(GamePlayState state) {
    if (state.player?.id == state.room.nextPlayer?.id) {
      _playerTurn.text = "Your\nTurn";
      anchor = Anchor.centerLeft;
      gameRef.overlays.add(RouteKey.yourTurn);
      Future.delayed(const Duration(seconds: 2)).then((_) {
        gameRef.overlays.remove(RouteKey.yourTurn);
      });
    } else {
      _playerTurn.text = "Opponent's\nTurn";
      anchor = Anchor.centerLeft;
      gameRef.overlays.add(RouteKey.opponentTurn);
      Future.delayed(const Duration(seconds: 2)).then((_) {
        gameRef.overlays.remove(RouteKey.opponentTurn);
      });
    }
    super.onNewState(state);
  }

  @override
  void onGameResize(Vector2 size) {
    position = Vector2(-size.x / 2 + 30, -50);
    super.onGameResize(size);
  }

  @override
  bool listenWhen(GamePlayState previousState, GamePlayState newState) {
    return newState.action == GameAction.nextTurn;
  }
}
