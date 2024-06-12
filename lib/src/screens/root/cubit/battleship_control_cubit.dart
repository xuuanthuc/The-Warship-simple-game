import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:template/src/components/blue_sea_component.dart';
import 'package:template/src/models/battle.dart';
import 'package:template/src/models/blue_sea.dart';
import '../../../components/battleship_component.dart';
import '../../../global/utilities/game_data.dart';

part 'battleship_control_state.dart';

@injectable
class BattleshipControlCubit extends Cubit<BattleshipControlState> {
  BattleshipControlCubit() : super(BattleshipControlState.empty());

  void checkCollisionBlocks(List<BattleshipComponent> components) {
    if (components.any((b) => b.collisions.isNotEmpty)) {
      emit(state.copyWith(
        status: GameStatus.prepare,
        action: GameAction.prepare,
      ));
    } else {
      emit(state.copyWith(
        status: GameStatus.ready,
        action: GameAction.prepare,
      ));
    }
  }

  void shuffleShipPosition(List<BattleshipComponent> components) async {
    final List<BlueSea> _targetSea = [];
    _targetSea.addAll(GameData.instance.seaBlocks);

    /// init [_targetSea] with length = [GameData.instance.seaBlocks]
    for (final BattleshipComponent ship in components) {
      final _random = new Random();
      ship.angle = _random.nextInt(2) == 0 ? radians(90) : 0;
      changeValidPosition(_random, ship, components, _targetSea);
    }
  }

  void changeValidPosition(
    Random _random,
    BattleshipComponent ship,
    List<BattleshipComponent> components,
    List<BlueSea> targetSea,
  ) {
    /// create [target] is random [BlueSea] in target list
    var target = targetSea[_random.nextInt(targetSea.length)];
    final targetPosition = target.vector2 ?? Vector2.zero();

    /// set new position for BattleshipSprite
    ship.handlePosition(targetPosition);

    /// Remove sea's item if it contains in ship's overlapping list
    targetSea.removeWhere((tg) => ship.overlappingSeaBlocks.contains(tg));

    /// Check if one ship's overlapping list have at least one target contains with other ship. If has, create new position for ship
    if (ship.overlappingSeaBlocks.any((sp) => components
        .any((cp) => cp != ship && cp.overlappingSeaBlocks.contains(sp)))) {
      changeValidPosition(_random, ship, components, targetSea);
    }
  }

  void createLayoutBattle(
    List<BattleshipComponent> ships,
    List<BlueSeaComponent> blocks,
  ) {
    List<Battle> battles = [];
    for (final BlueSeaComponent block in blocks) {
      final newBattleSquare = Battle(
        blueSea: block.blueSea,
        status: BattleSquareStatus.undefined,
        type: ships.any(
                (ship) => ship.overlappingSeaBlocks.contains(block.blueSea))
            ? BattleSquareType.ship
            : BattleSquareType.sea,
      );
      battles.add(newBattleSquare);
    }
    emit(state.copyWith(battles: battles, action: GameAction.ready));
  }

  void shootEnemy(Battle battle) {
    if(battle.status == BattleSquareStatus.determined) return;
    battle.status = BattleSquareStatus.determined;

  }
}
