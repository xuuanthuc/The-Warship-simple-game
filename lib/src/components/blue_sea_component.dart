import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:template/src/global/style/app_images.dart';
import 'package:template/src/global/utilities/game_data.dart';

import '../models/blue_sea.dart';
import '../screens/root/cubit/battleship_control_cubit.dart';

class BlueSeaComponent extends SpriteComponent
    with FlameBlocReader<BattleshipControlCubit, BattleshipControlState> {
  final BlueSea blueSea;
  final int index;

  BlueSeaComponent({
    required this.blueSea,
    required this.index,
  });

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(AppImages.blueSea);
    position = blueSea.vector2 ?? Vector2.zero();
    anchor = Anchor.center;
    size = Vector2.all(GameData.instance.blockSize);
    add(
      TextComponent(
        text: "${blueSea.coordinates?.join(" - ")}",
        anchor: Anchor.center,
        position: Vector2.all(GameData.instance.blockSize / 2),
        textRenderer: TextPaint(
          style: TextStyle(color: Colors.black)
        )
      ),
    );
    return super.onLoad();
  }
}