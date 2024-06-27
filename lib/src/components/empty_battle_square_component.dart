import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_lottie/flame_lottie.dart';
import 'package:template/src/models/battle.dart';
import '../bloc/game_play/game_play_cubit.dart';
import '../style/app_images.dart';
import '../utilities/game_data.dart';

class EmptyBattleSquareComponent extends SpriteComponent
    with
        FlameBlocReader<GamePlayCubit, GamePlayState>,
        TapCallbacks,
        DragCallbacks {
  final EmptyBattleSquare battle;

  EmptyBattleSquareComponent({
    required this.battle,
  });

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(AppImages.blueSea);
    position = battle.block.vector2 ?? Vector2.zero();
    anchor = Anchor.center;
    priority = 2;
    size = Vector2.all(GameData.instance.blockSize);
    // if (battle.type == BattleSquareType.occupied) {
    //   add(
    //     TextComponent(
    //       text: "${battle.block.coordinates?.join(" - ")}",
    //       anchor: Anchor.center,
    //       position: Vector2.all(GameData.instance.blockSize / 2),
    //       textRenderer: TextPaint(
    //         style: TextStyle(color: Colors.black),
    //       ),
    //     ),
    //   );
    // }
    add(ShootPointSprite(battle: battle));
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) async {
    bloc.shootEnemy(battle);
    super.onTapUp(event);
  }
}

class ShootPointSprite extends SpriteComponent
    with HasVisibility, FlameBlocListenable<GamePlayCubit, GamePlayState> {
  final EmptyBattleSquare battle;

  ShootPointSprite({required this.battle});

  bool _isDetermined = false;

  @override
  Future<void> onLoad() async {
    isVisible = false;
    sprite = await Sprite.load(AppImages.invisibleShip);
    size = Vector2.all(GameData.instance.blockSize);
    position = Vector2.zero();
    return super.onLoad();
  }

  @override
  void onNewState(GamePlayState state) async {
    if (battle.status == BattleSquareStatus.determined &&
        _isDetermined == false) {
      _isDetermined = true;
      isVisible = battle.status == BattleSquareStatus.determined;
      final asset = Lottie.asset(
        battle.type == BattleSquareType.empty
            ? AppImages.water
            : AppImages.explode,
      );
      final animation = await loadLottie(asset);
      await add(
        LottieComponent(
          animation,
          repeating: false, // continuously loop the animation
          size: Vector2.all(GameData.instance.blockSize),
        ),
      );

      Future.delayed(const Duration(seconds: 1)).then(
        (_) async => sprite = await Sprite.load(
          battle.type == BattleSquareType.occupied
              ? AppImages.hasShip
              : AppImages.nonShip,
        ),
      );
    }
    super.onNewState(state);
  }

  @override
  bool listenWhen(GamePlayState previousState, GamePlayState newState) {
    return newState.action == GameAction.checkSunk && _isDetermined == false;
  }
}
