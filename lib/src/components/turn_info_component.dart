import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:template/src/screens/game_play/game_play.dart';
import 'package:template/src/utilities/game_data.dart';

import '../bloc/game_play/game_play_cubit.dart';
import '../routes/route_keys.dart';

class TurnInfoComponent extends TextComponent
    with
        HasGameRef<BattleGameFlame>,
        FlameBlocListenable<GamePlayCubit, GamePlayState> {
  TextComponent _playerTurn = TextComponent(
    text: '',
    textRenderer: TextPaint(
      style: TextStyle(
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
      _playerTurn.text = "Your turn";
      position = Vector2(-(GameData.blockLength * GameData.instance.blockSize),
          -(GameData.blockLength * GameData.instance.blockSize / 2));
      gameRef.overlays.add(RouteKey.yourTurn);
      Future.delayed(Duration(seconds: 2)).then((_) {
        gameRef.overlays.remove(RouteKey.yourTurn);
      });
    } else {
      _playerTurn.text = "Opponent turn";
      position = Vector2(GameData.blockLength * (GameData.instance.blockSize / 1.5),
          -(GameData.blockLength * GameData.instance.blockSize / 2));
      gameRef.overlays.add(RouteKey.opponentTurn);
      Future.delayed(Duration(seconds: 2)).then((_) {
        gameRef.overlays.remove(RouteKey.opponentTurn);
      });
    }
    super.onNewState(state);
  }

  @override
  bool listenWhen(GamePlayState previousState, GamePlayState newState) {
    return newState.action == GameAction.nextTurn;
  }
}
