import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import '../bloc/game_play/game_play_cubit.dart';
import '../style/app_images.dart';
import '../utilities/game_data.dart';

class TerrainComponent extends SpriteComponent
    with FlameBlocListenable<GamePlayCubit, GamePlayState> {
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(AppImages.background);
    anchor = Anchor.center;
    size = Vector2.all(GameData.instance.blockSize * GameData.blockLength);
    return super.onLoad();
  }

  @override
  void onNewState(GamePlayState state) {
    if(state.status.index <= 4) {
      priority = -1;
    } else {
      priority = 1;
    }
    super.onNewState(state);
  }

  @override
  bool listenWhen(GamePlayState previousState, GamePlayState newState) {
    return previousState.status != newState.status;
  }
}
