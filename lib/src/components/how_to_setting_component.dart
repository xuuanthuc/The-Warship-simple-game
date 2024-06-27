import 'dart:async';
import 'package:flame/components.dart';
import '../style/app_images.dart';
import '../utilities/game_data.dart';

class HowToSettingComponent extends SpriteComponent {
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load(AppImages.setting);
    anchor = Anchor.centerLeft;
    size = Vector2(GameData.instance.blockSize * 2,GameData.instance.blockSize * 6);
    position = Vector2(GameData.instance.blockSize * (GameData.blockLength  + 2.5) / 2, 0);
    return super.onLoad();
  }
}
