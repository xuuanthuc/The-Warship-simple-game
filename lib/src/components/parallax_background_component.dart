import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

import '../global/style/app_images.dart';
import '../screens/root/root_screen.dart';

class MyParallaxComponent extends ParallaxComponent<MyGame>
    with HasGameRef<MyGame> {
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
