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
    priority = -1;
    return super.onLoad();
  }
}
