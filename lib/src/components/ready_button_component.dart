import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:template/src/global/style/app_images.dart';
import 'package:template/src/global/utilities/game_data.dart';
import 'package:template/src/screens/root/cubit/battleship_control_cubit.dart';

class ReadyButtonComponent extends PositionComponent
    with FlameBlocListenable<BattleshipControlCubit, BattleshipControlState> {
  SpriteComponent? _button;

  @override
  Future<void> onLoad() async {
    final sprite = await Sprite.load(AppImages.readyButton);
    _button = SpriteComponent(sprite: sprite, anchor: Anchor.center);
    anchor = Anchor.center;
    add(_button!);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    final game = GameData.instance;
    position = game.screenSize.width < game.screenSize.height
        ? Vector2(
            game.screenSize.width / 2,
            game.blockSize * GameData.blockLength * 1.7,
          )
        : Vector2(game.blockSize * GameData.blockLength * 2,
            game.blockSize * GameData.blockLength);
    super.onGameResize(size);
  }

  @override
  void onNewState(BattleshipControlState state) {
    if (_button == null) return;
    if (state.isPrepared == true) {
      if (_button!.isRemoved) add(_button!);
    } else {
      if (_button!.isMounted) remove(_button!);
    }
    super.onNewState(state);
  }
}
