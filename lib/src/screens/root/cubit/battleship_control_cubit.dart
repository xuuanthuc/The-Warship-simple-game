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
import 'package:collection/collection.dart';

part 'battleship_control_state.dart';

@injectable
class BattleshipControlCubit extends Cubit<BattleshipControlState> {
  BattleshipControlCubit() : super(BattleshipControlState.empty());

  void printInstance(){
    print(this.hashCode);
  }

  void checkCollisionBlocks(List<BattleshipComponent> components) {
    if (components.any((b) => b.collisions.isNotEmpty)) {
      emit(state.copyWith(
        status: GameStatus.preparing,
        action: GameAction.prepare,
      ));
    } else {
      emit(state.copyWith(
        status: GameStatus.prepared,
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
    final index = _random.nextInt(targetSea.length);
    var target = targetSea[index];
    final targetPosition = target.vector2 ?? Vector2.zero();
    /// set new position for BattleshipSprite
    ship.targetPoint = target;
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
    List<SeaInBattle> seaBlocks = [];
    List<ShipInBattle> shipBlocks = [];

    for (final BattleshipComponent ship in ships) {
      final newShipSquare = ShipInBattle(
        positions: ship.overlappingSeaBlocks,
        ship: ship.battleship,
        angle: ship.angle,
        centerPoint: ship.targetPoint,
      );
      shipBlocks.add(newShipSquare);
    }

    for (final BlueSeaComponent block in blocks) {
      final ship = ships.firstWhereOrNull(
          (ship) => ship.overlappingSeaBlocks.contains(block.blueSea));
      final newBattleSquare = SeaInBattle(
        blueSea: block.blueSea,
        status: BattleSquareStatus.undefined,
        type: ship != null ? BattleSquareType.ship : BattleSquareType.sea,
      );
      seaBlocks.add(newBattleSquare);
    }

    emit(state.copyWith(
      battles: seaBlocks,
      ships: shipBlocks,
      action: GameAction.ready,
      status: GameStatus.ready,
    ));
  }

  void shootEnemy(SeaInBattle battle) {
    if (battle.status == BattleSquareStatus.determined) return;
    emit(state.copyWith(action: GameAction.shoot));
    battle.status = BattleSquareStatus.determined;
    state.ships.forEach((ship){
      ship.positions.removeWhere((ps) => ps.coordinates == battle.blueSea.coordinates);
    });
    emit(state.copyWith(action: GameAction.checkSunk));
  }
}
