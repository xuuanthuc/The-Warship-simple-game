import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:template/src/global/utilities/game_data.dart';
import 'package:template/src/models/battleship.dart';
import 'package:template/src/screens/root/cubit/battleship_control_cubit.dart';

class BattleshipComponent extends SpriteComponent
    with
        DragCallbacks,
        TapCallbacks,
        FlameBlocReader<BattleshipControlCubit, BattleshipControlState>,
        FlameBlocListenable<BattleshipControlCubit, BattleshipControlState> {
  final Battleship battleship;

  BattleshipComponent({required this.battleship});

  @override
  Future<void> onLoad() async {
    sprite = await setBattleshipSprite();
    position = Vector2(200, 100);
    anchor = Anchor.center;
    size = setBattleshipSize();
    return super.onLoad();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
    print(position);
    super.onDragUpdate(event);
  }

  @override
  void onDragStart(DragStartEvent event) {
    scale = Vector2(1.1, 1.1);
    super.onDragStart(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    scale = Vector2(1, 1);
    super.onDragEnd(event);
  }

  @override
  void onTapUp(TapUpEvent event) async {
    battleship.symmetric =
        battleship.symmetric == BattleshipSymmetric.horizontal
            ? BattleshipSymmetric.vertical
            : BattleshipSymmetric.horizontal;
    size = setBattleshipSize();
    sprite = await setBattleshipSprite();

    super.onTapUp(event);
  }

  Future<Sprite> setBattleshipSprite() async {
    return await Sprite.load(
      battleship.symmetric == BattleshipSymmetric.horizontal
          ? battleship.horizontalSprite
          : battleship.verticalSprite,
    );
  }

  Vector2 setBattleshipSize() {
    return battleship.symmetric == BattleshipSymmetric.horizontal
        ? Vector2(GameData.instance.blockSize * battleship.size,
            GameData.instance.blockSize)
        : Vector2(GameData.instance.blockSize,
            GameData.instance.blockSize * battleship.size);
  }
}
