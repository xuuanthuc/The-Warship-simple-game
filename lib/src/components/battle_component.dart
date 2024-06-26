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

  @override
  FutureOr<void> onLoad() async {
    size = Vector2.all(GameData.instance.blockSize * GameData.blockLength);
    for (var i = 0; i < emptySquares.length; i++) {
      EmptyBattleSquare block = emptySquares[i];
      block.block.vector2 = GameData.instance.setBlockVector2(
        block.block.coordinates!.last,
        block.block.coordinates!.first,
      );
      await add(
        EmptyBattleSquareComponent(
          battle: emptySquares[i],
        ),
      );
    }
    for (var i = 0; i < occupiedSquares.length; i++) {
      final ship = occupiedSquares[i];
      await add(
        OccupiedBattleSquareComponent(
          key: ComponentKey.unique(),
          square: ship,
          index: i,
          isGuest: true,
          initialAngle: ship.angle.toDouble(),
          initialPosition: GameData.instance.setBlockVector2(
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

  @override
  FutureOr<void> onLoad() async {
    size = Vector2.all(GameData.instance.blockSize * GameData.blockLength);
    for (var i = 0; i < emptySquares.length; i++) {
      EmptyBattleSquare block = emptySquares[i];
      block.block.vector2 = GameData.instance.setBlockVector2(
        block.block.coordinates!.last,
        block.block.coordinates!.first,
      );
      await add(
        EmptyBattleSquareComponent(
          battle: emptySquares[i],
        ),
      );
    }
    for (var i = 0; i < occupiedSquares.length; i++) {
      final ship = occupiedSquares[i];
      await add(
        OccupiedBattleSquareComponent(
          key: ComponentKey.unique(),
          square: ship,
          index: i,
          initialAngle: ship.angle.toDouble(),
          isGuest: false,
          initialPosition: GameData.instance.setBlockVector2(
            ship.targetPoint!.coordinates!.last,
            ship.targetPoint!.coordinates!.first,
          ),
        ),
      );
    }
    return super.onLoad();
  }
}
