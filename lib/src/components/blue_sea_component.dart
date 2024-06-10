import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:template/src/global/style/app_images.dart';
import 'package:template/src/global/utilities/game_data.dart';

import '../screens/root/cubit/battleship_control_cubit.dart';

class BlueSeaComponent extends SpriteComponent with FlameBlocReader<BattleshipControlCubit, BattleshipControlState>{
  final Vector2 vector2;

  BlueSeaComponent({required this.vector2});

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(AppImages.blueSea);
    position = vector2;
    anchor = Anchor.center;
    size = Vector2.all(GameData.instance.blockSize);
    return super.onLoad();
  }
}