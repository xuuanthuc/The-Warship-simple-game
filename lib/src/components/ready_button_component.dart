import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:template/src/style/app_images.dart';
import 'package:template/src/utilities/game_data.dart';
import '../bloc/game_play/game_play_cubit.dart';
import '../screens/game_play/game_play.dart';
import 'occupied_component.dart';
import 'empty_square_component.dart';

class ReadyButtonComponent extends SpriteComponent
    with
        HasGameRef<BattleGameFlame>,
        FlameBlocListenable<GamePlayCubit, GamePlayState>,
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
      gameRef.world.children.query<OccupiedComponent>(),
      gameRef.world.children.query<EmptySquareComponent>(),
    );
    super.onTapUp(event);
  }

  @override
  void onNewState(GamePlayState state) {
    if (state.status == GameStatus.prepared) {
      this.isVisible = true;
    } else {
      this.isVisible = false;
    }
    super.onNewState(state);
  }
}
