import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:template/src/components/empty_battle_square_component.dart';
import 'package:template/src/components/occupied_battle_square_component.dart';
import 'package:template/src/utilities/game_data.dart';
import '../bloc/game_play/game_play_cubit.dart';
import '../models/battle.dart';

class GuestBattleWorld extends PositionComponent
    with FlameBlocListenable<GamePlayCubit, GamePlayState> {
  final List<EmptyBattleSquare> emptySquares;
  final List<OccupiedBattleSquare> occupiedSquares;

  GuestBattleWorld({
    required this.emptySquares,
    required this.occupiedSquares,
  });

  Vector2 setBlockVector2(int xIndex, int yIndex) {
    final size = GameData.instance.blockSize;
    return Vector2(
      (xIndex.toDouble() * size) -
          (size * GameData.blockLength / 2) +
          (size / 2),
      (yIndex.toDouble() * size) -
          (size * GameData.blockLength / 2) +
          (size / 2),
    );
  }

  @override
  FutureOr<void> onLoad() async {
    size = Vector2.all(GameData.instance.blockSize * GameData.blockLength);
    for (var i = 0; i < emptySquares.length; i++) {
      EmptyBattleSquare block = emptySquares[i];
      block.block.vector2 = setBlockVector2(
        block.block.coordinates!.last,
        block.block.coordinates!.first,
      );
      await add(
        EmptyBattleSquareComponent(
          battle: emptySquares[i],
        ),
      );
    }
    await Future.delayed(const Duration(milliseconds: 300));
    for (var i = 0; i < occupiedSquares.length; i++) {
      final ship = occupiedSquares[i];
      await add(
        OccupiedBattleSquareComponent(
          key: ComponentKey.unique(),
          square: ship,
          index: i,
          initialAngle: ship.angle.toDouble(),
          vectors: emptySquares,
          initialPosition: setBlockVector2(
            ship.targetPoint!.coordinates!.last,
            ship.targetPoint!.coordinates!.first,
          ),
        ),
      );
    }
    return super.onLoad();
  }
}

class OwnerBattleWorld extends PositionComponent
    with FlameBlocListenable<GamePlayCubit, GamePlayState> {
  final List<EmptyBattleSquare> emptySquares;
  final List<OccupiedBattleSquare> occupiedSquares;

  OwnerBattleWorld({
    required this.emptySquares,
    required this.occupiedSquares,
  });

  Vector2 setBlockVector2(int xIndex, int yIndex) {
    return Vector2(
      (xIndex.toDouble() * GameData.instance.blockSize) -
          (GameData.instance.blockSize * GameData.blockLength / 2) +
          (GameData.instance.blockSize / 2),
      (yIndex.toDouble() * GameData.instance.blockSize) -
          (GameData.instance.blockSize * GameData.blockLength / 2) +
          (GameData.instance.blockSize / 2),
    );
  }

  @override
  FutureOr<void> onLoad() async {
    size = Vector2.all(GameData.instance.blockSize * GameData.blockLength);
    for (var i = 0; i < emptySquares.length; i++) {
      EmptyBattleSquare block = emptySquares[i];
      block.block.vector2 = setBlockVector2(
        block.block.coordinates!.last,
        block.block.coordinates!.first,
      );
      await add(
        EmptyBattleSquareComponent(
          battle: emptySquares[i],
        ),
      );
    }
    await Future.delayed(const Duration(milliseconds: 300));
    for (var i = 0; i < occupiedSquares.length; i++) {
      final ship = occupiedSquares[i];
      await add(
        OccupiedBattleSquareComponent(
          key: ComponentKey.unique(),
          square: ship,
          index: i,
          initialAngle: ship.angle.toDouble(),
          vectors: emptySquares,
          initialPosition: setBlockVector2(
            ship.targetPoint!.coordinates!.last,
            ship.targetPoint!.coordinates!.first,
          ),
        ),
      );
    }
    return super.onLoad();
  }
}
