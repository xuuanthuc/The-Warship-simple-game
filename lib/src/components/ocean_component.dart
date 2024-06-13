import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import '../global/style/app_images.dart';
import '../global/utilities/game_data.dart';
import '../screens/root/cubit/battleship_control_cubit.dart';

class OceanSprite extends SpriteComponent
    with FlameBlocListenable<BattleshipControlCubit, BattleshipControlState> {
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(AppImages.background);
    anchor = Anchor.center;
    size = Vector2.all(GameData.instance.blockSize * GameData.blockLength);
    return super.onLoad();
  }

  @override
  void onNewState(BattleshipControlState state) {
    if(state.status.index <= 4) {
      priority = -1;
    } else {
      priority = 1;
    }
    super.onNewState(state);
  }

  @override
  bool listenWhen(BattleshipControlState previousState, BattleshipControlState newState) {
    return previousState.status != newState.status;
  }
}
