import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:template/src/models/battle.dart';
import '../bloc/game_play/game_play_cubit.dart';
import '../style/app_images.dart';
import '../utilities/game_data.dart';

class SeaInBattleComponent extends SpriteComponent
    with
        FlameBlocReader<GamePlayCubit, GamePlayState>,
        TapCallbacks,
        DragCallbacks {
  final SeaInBattle battle;

  SeaInBattleComponent({
    required this.battle,
  });

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(AppImages.blueSea);
    position = battle.blueSea.vector2 ?? Vector2.zero();
    anchor = Anchor.center;
    priority = 2;
    size = Vector2.all(GameData.instance.blockSize);
    if (battle.type == BattleSquareType.ship) {
      add(
        TextComponent(
          text: "${battle.blueSea.coordinates?.join(" - ")}",
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
  final SeaInBattle battle;

  ShootPointSprite({required this.battle});

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(battle.type == BattleSquareType.ship
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
