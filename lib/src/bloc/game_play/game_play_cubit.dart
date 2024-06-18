import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:template/src/components/empty_square_component.dart';
import 'package:template/src/models/battle.dart';
import 'package:template/src/models/empty_block.dart';
import 'package:collection/collection.dart';
import 'package:template/src/models/player.dart';
import 'package:template/src/models/room_data.dart';

import '../../components/occupied_component.dart';
import '../../utilities/game_data.dart';

part 'game_play_state.dart';

@injectable
class GamePlayCubit extends Cubit<GamePlayState> {
  GamePlayCubit() : super(GamePlayState.empty());
  final firebase = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _roomStream;

  void checkCollisionBlocks(List<OccupiedComponent> components) {
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

  void getRoomDataToPrepareBattleGame(RoomData room, Player player) {
    emit(state.copyWith(room: room, player: player));
  }

  void shuffleOccupiedPosition(List<OccupiedComponent> components) async {
    final List<EmptyBlock> _target = [];
    _target.addAll(GameData.instance.emptyBlocks);

    /// init [_targetSea] with length = [GameData.instance.seaBlocks]
    for (final OccupiedComponent component in components) {
      final _random = new Random();
      component.angle = _random.nextInt(2) == 0 ? radians(90) : 0;
      changeValidPosition(_random, component, components, _target);
    }
  }

  void changeValidPosition(
    Random _random,
    OccupiedComponent ship,
    List<OccupiedComponent> components,
    List<EmptyBlock> targets,
  ) {
    /// create [target] is random [BlueSea] in target list
    final index = _random.nextInt(targets.length);
    var target = targets[index];
    final targetPosition = target.vector2 ?? Vector2.zero();

    /// set new position for BattleshipSprite
    ship.targetPoint = target;
    ship.handlePosition(targetPosition);

    /// Remove sea's item if it contains in ship's overlapping list
    targets.removeWhere((tg) => ship.overlappingEmptyBlocks.contains(tg));

    /// Check if one ship's overlapping list have at least one target contains with other ship. If has, create new position for ship
    if (ship.overlappingEmptyBlocks.any((sp) => components
        .any((cp) => cp != ship && cp.overlappingEmptyBlocks.contains(sp)))) {
      changeValidPosition(_random, ship, components, targets);
    }
  }

  void readyForBattle({
    required List<OccupiedComponent> occupiedItems,
    required List<EmptySquareComponent> blocks,
  }) {
    List<EmptyBattleSquare> emptyBlocks = [];
    List<OccupiedBattleSquare> occupiedBlocks = [];
    final room = state.room;
    final player = state.player;
    if (room == null || player == null) return;
    final hostPlayer = room.ownerPlayer;
    final iamHost = hostPlayer != null && player.id == hostPlayer.id;

    for (final OccupiedComponent occupied in occupiedItems) {
      final newShipSquare = OccupiedBattleSquare(
        overlappingPositions: occupied.overlappingEmptyBlocks,
        block: occupied.block,
        angle: occupied.angle,
        targetPoint: occupied.targetPoint,
      );
      occupiedBlocks.add(newShipSquare);
    }

    for (final EmptySquareComponent block in blocks) {
      final item = occupiedItems.firstWhereOrNull(
          (ship) => ship.overlappingEmptyBlocks.contains(block.blueSea));
      final newBattleSquare = EmptyBattleSquare(
        block: block.blueSea,
        status: BattleSquareStatus.undefined,
        type: item != null ? BattleSquareType.occupied : BattleSquareType.empty,
      );
      emptyBlocks.add(newBattleSquare);
    }
    if (iamHost) {
      room.ownerPlayingData = PlayingData(
        emptyBlocks: emptyBlocks,
        occupiedBlocks: occupiedBlocks,
      );
      firebase
          .collection("rooms")
          .doc(room.code)
          .set(room.toFireStore(), SetOptions(merge: true))
          .then((value) {
        setRoomDataStreamSubscription();
      });
    } else {
      room.opponentPlayingData = PlayingData(
        emptyBlocks: emptyBlocks,
        occupiedBlocks: occupiedBlocks,
      );
      firebase
          .collection("rooms")
          .doc(room.code)
          .set(room.toFireStore(), SetOptions(merge: true))
          .then((value) {
        setRoomDataStreamSubscription();
      });
    }
  }

  void createLayoutBattle(
    List<EmptyBattleSquare> seaBlocks,
    List<OccupiedBattleSquare> shipBlocks,
  ) {
    emit(state.copyWith(
      battles: seaBlocks,
      ships: shipBlocks,
      action: GameAction.ready,
      status: GameStatus.ready,
    ));
  }

  void shootEnemy(EmptyBattleSquare battle) {
    if (battle.status == BattleSquareStatus.determined) return;
    emit(state.copyWith(action: GameAction.shoot));
    battle.status = BattleSquareStatus.determined;
    state.occupiedSquares.forEach((ship) {
      ship.overlappingPositions
          .removeWhere((ps) => ps.coordinates == battle.block.coordinates);
    });
    emit(state.copyWith(action: GameAction.checkSunk));
  }

  void setRoomDataStreamSubscription() {
    _roomStream = firebase
        .collection("rooms")
        .doc(state.room?.code)
        .snapshots()
        .listen((roomData) async {
      emit(state.copyWith(
        room: roomData.data() != null ? RoomData.fromFireStore(roomData) : null,
      ));
      await Future.delayed(Duration(milliseconds: 200));
      final room = state.room;
      final player = state.player;
      if (room == null || player == null) return;
      final hostPlayer = room.ownerPlayer;
      final iamHost = hostPlayer != null && player.id == hostPlayer.id;
      if (room.ownerPlayingData != null &&
          room.opponentPlayingData != null &&
          (room.opponentPlayingData?.emptyBlocks ?? []).isNotEmpty &&
          (room.opponentPlayingData?.occupiedBlocks ?? []).isNotEmpty &&
          (room.ownerPlayingData?.emptyBlocks ?? []).isNotEmpty &&
          (room.ownerPlayingData?.occupiedBlocks ?? []).isNotEmpty) {
        if (iamHost) {
          createLayoutBattle(
            room.opponentPlayingData?.emptyBlocks ?? [],
            room.opponentPlayingData?.occupiedBlocks ?? [],
          );
        } else {
          createLayoutBattle(
            room.ownerPlayingData?.emptyBlocks ?? [],
            room.ownerPlayingData?.occupiedBlocks ?? [],
          );
        }
      }
    });
  }
}
