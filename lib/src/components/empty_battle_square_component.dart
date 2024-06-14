import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
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
    if (battle.type == BattleSquareType.occupied) {
      add(
        TextComponent(
          text: "${battle.block.coordinates?.join(" - ")}",
          anchor: Anchor.center,
          position: Vector2.all(GameData.instance.blockSize / 2),
          textRenderer: TextPaint(
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }
    add(ShootPointSprite(battle: battle));
    return super.onLoad();
  }

  @override
  void onTapUp(TapUpEvent event) {
    bloc.shootEnemy(battle);
    super.onTapUp(event);
  }
}

class ShootPointSprite extends SpriteComponent with HasVisibility {
  final EmptyBattleSquare battle;

  ShootPointSprite({required this.battle});

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(battle.type == BattleSquareType.occupied
        ? AppImages.hasShip
        : AppImages.nonShip);
    size = Vector2.all(GameData.instance.blockSize);
    position = Vector2.zero();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    isVisible = battle.status == BattleSquareStatus.determined;
    super.update(dt);
  }
}
