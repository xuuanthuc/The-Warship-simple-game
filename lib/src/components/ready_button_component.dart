import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:template/src/global/style/app_images.dart';
import 'package:template/src/global/utilities/game_data.dart';
import 'package:template/src/screens/root/cubit/battleship_control_cubit.dart';

class ReadyButtonComponent extends SpriteComponent
    with
        FlameBlocListenable<BattleshipControlCubit, BattleshipControlState>,
        HasVisibility {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(AppImages.readyButton);
    anchor = Anchor.center;
    isVisible = false;
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
    if (state.status == GameStatus.ready) {
      this.isVisible = true;
    } else {
      this.isVisible = false;
    }
    super.onNewState(state);
  }
}
