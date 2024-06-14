import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

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
      baseVelocity: Vector2(5, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
      filterQuality: FilterQuality.none,
    );
  }
}
