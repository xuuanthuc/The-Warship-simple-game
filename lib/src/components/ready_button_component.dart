import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:template/src/global/style/app_images.dart';
import 'package:template/src/global/utilities/game_data.dart';
import 'package:template/src/screens/root/cubit/battleship_control_cubit.dart';

import '../screens/root/root_screen.dart';
import 'battleship_component.dart';
import 'blue_sea_component.dart';

class ReadyButtonComponent extends SpriteComponent
    with
        HasGameRef<MyGame>,
        FlameBlocListenable<BattleshipControlCubit, BattleshipControlState>,
        HasVisibility,
        TapCallbacks {

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(AppImages.readyButton);
    anchor = Anchor.center;
    isVisible = false;
    final game = GameData.instance;
    position = Vector2(0, game.blockSize * GameData.blockLength / 2 + 80);
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    bloc.createLayoutBattle(
      gameRef.world.children.query<BattleshipComponent>(),
      gameRef.world.children.query<BlueSeaComponent>(),
    );
    super.onTapUp(event);
  }

  @override
  void onNewState(BattleshipControlState state) {
    if (state.status == GameStatus.prepared) {
      this.isVisible = true;
    } else {
      this.isVisible = false;
    }
    super.onNewState(state);
  }
}
