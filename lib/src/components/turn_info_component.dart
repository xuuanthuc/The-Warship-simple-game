import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:template/src/utilities/game_data.dart';

import '../bloc/game_play/game_play_cubit.dart';

class TurnInfoComponent extends TextComponent
    with FlameBlocListenable<GamePlayCubit, GamePlayState> {
  TextComponent _playerTurn = TextComponent(
    text: '',
    textRenderer: TextPaint(
      style: TextStyle(
        color: Colors.black,
        fontSize: 40,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  @override
  Future<void> onLoad() async {
    position = Vector2(
        0, - (GameData.blockLength * GameData.instance.blockSize / 2) - 30);
    anchor = Anchor.center;
    priority = 10;
    add(_playerTurn);
    return super.onLoad();
  }

  @override
  void onNewState(GamePlayState state) {
    if (state.player?.id == state.room.nextPlayer?.id) {
      _playerTurn.text = "Your turn";
    } else {
      _playerTurn.text = "Opponent turn";
    }
    super.onNewState(state);
  }

  @override
  bool listenWhen(GamePlayState previousState, GamePlayState newState) {
    return newState.action == GameAction.nextTurn;
  }
}
