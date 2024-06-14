import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:template/src/style/app_images.dart';
import 'package:template/src/utilities/game_data.dart';
import '../bloc/game_play/game_play_cubit.dart';
import '../models/empty_block.dart';

class EmptySquareComponent extends SpriteComponent
    with FlameBlocReader<GamePlayCubit, GamePlayState> {
  final EmptyBlock blueSea;
  final int index;

  EmptySquareComponent({
    required this.blueSea,
    required this.index,
  });

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(AppImages.blueSea);
    position = blueSea.vector2 ?? Vector2.zero();
    anchor = Anchor.center;
    size = Vector2.all(GameData.instance.blockSize);
    // add(
    //   TextComponent(
    //     text: "${blueSea.coordinates?.join(" - ")}",
    //     anchor: Anchor.center,
    //     position: Vector2.all(GameData.instance.blockSize / 2),
    //     textRenderer: TextPaint(
    //       style: TextStyle(color: Colors.black)
    //     )
    //   ),
    // );
    return super.onLoad();
  }
}