import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

import '../screens/game_play/game_play.dart';
import '../style/app_images.dart';

class MyParallaxComponent extends ParallaxComponent<BattleGameFlame>
    with HasGameRef<BattleGameFlame> {
  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData(AppImages.parallax),
      ],
      baseVelocity: Vector2(-5, 10),
      velocityMultiplierDelta: Vector2(2, 3),
      repeat: ImageRepeat.repeat,
      alignment: Alignment.center,
      filterQuality: FilterQuality.none,
    );
  }
}
