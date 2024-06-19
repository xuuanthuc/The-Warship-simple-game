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
import 'package:template/src/utilities/logger.dart';
import '../../components/occupied_component.dart';
import '../../utilities/game_data.dart';

part 'game_play_state.dart';

@injectable
class GamePlayCubit extends Cubit<GamePlayState> {
  GamePlayCubit() : super(GamePlayState.empty());
  final firebase = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _roomStream;

  void checkCollisionBlocks(List<OccupiedComponent> components) {
    /// When collision started or ended, if have not any blocks in collisions changed status
    if (components.any((b) => b.collisions.isNotEmpty)) {
      emit(state.copyWith(
        status: ReadyStatus.preparing,
        action: GameAction.prepare,
      ));
    } else {
      emit(state.copyWith(
        status: ReadyStatus.prepared,
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
  }) async {
    List<EmptyBattleSquare> emptyBlocks = [];
    List<OccupiedBattleSquare> occupiedBlocks = [];
    final room = state.room;
    final player = state.player;
    if (player == null) return;
    final hostPlayer = room.ownerPlayer;
    final iamHost = hostPlayer != null && player.id == hostPlayer.id;

    /// Send all positions data to firebase
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
          .then((_) {
        _listenGameReadyStatus();
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
          .then((_) {
        _listenGameReadyStatus();
      });
    }
  }

  void shootEnemy(EmptyBattleSquare square) {
    if (state.room.nextPlayer == null ||
        state.player == null ||
        state.room.nextPlayer?.id != state.player?.id) return;
    if (square.status == BattleSquareStatus.determined) return;
    square.status = BattleSquareStatus.determined;
    print("tap how many time ???");
    print(square.hashCode);
    if (state.iamHost == true) {
      firebase
          .collection("rooms")
          .doc(state.room.code)
          .update(state.room.actionOfOwnerPlayer(square));
    } else {
      firebase
          .collection("rooms")
          .doc(state.room.code)
          .update(state.room.actionOfOccupiedPlayer(square));
    }
  }

  void _listenGameReadyStatus() {
    _roomStream = firebase
        .collection("rooms")
        .doc(state.room.code)
        .snapshots()
        .listen((roomData) async {
      /// If two player clicked Ready, when Firebase exists data of owner player and opponent player. Go to playing screen
      final room =
          roomData.data() != null ? RoomData.fromFireStore(roomData) : null;
      final player = state.player;
      if (room == null || player == null) return;
      final hostPlayer = room.ownerPlayer;
      final iamHost = hostPlayer != null && player.id == hostPlayer.id;
      if (room.ownerPlayingData != null && room.opponentPlayingData != null) {
        emit(state.copyWith(
          room: room,
          iamHost: iamHost,
          action: GameAction.ready,
          status: ReadyStatus.ready,
        ));
        ///Cancel stream subscription ready game state
        removeRoomDataStreamSubscription();
      }
    });
  }

  void removeRoomDataStreamSubscription() {
    _roomStream?.cancel();
    _roomStream = null;
  }

  void startGame(){
    emit(state.copyWith(action: GameAction.play));
    firebase
        .collection("rooms")
        .doc(state.room.code)
        .update(state.room.playGame(
      Random().nextInt(2) == 0
          ? state.room.ownerPlayer!
          : state.room.opponentPlayer!,
    ))
        .then((_) {
      ///Register new stream subscription game play data
      setRoomDataStreamSubscription();
    });
  }

  void setRoomDataStreamSubscription() {
    /// Set new stream listener for room game data to listen room data changed
    _roomStream = firebase
        .collection("rooms")
        .doc(state.room.code)
        .snapshots()
        .listen((roomData) async {
      emit(state.copyWith(action: GameAction.shoot));
      final room =
          roomData.data() != null ? RoomData.fromFireStore(roomData) : null;
      LoggerUtils.i(roomData.data());
      state.room.nextPlayer = room?.nextPlayer;
      final nextOwnerPlayerAction = room?.nextOwnerPlayerAction;
      final nextOpponentPlayerAction = room?.nextOpponentPlayerAction;
      ///Each occupied has a list of point that is overlapping, check point tapped have contain in this list.
      /// If contain, remove point, When overlapping list empty, change state of occupied from hide to show
      if (nextOwnerPlayerAction != null) {
        state.room.opponentPlayingData?.occupiedBlocks.forEach((ship) {
          ship.overlappingPositions.removeWhere(
            (ps) => ListEquality().equals(
              ps.coordinates,
              nextOwnerPlayerAction.block.coordinates,
            ),
          );
          LoggerUtils.i(ship.overlappingPositions);
        });
        final block = state.room.opponentPlayingData?.emptyBlocks.firstWhere(
          (b) => ListEquality().equals(
            b.block.coordinates,
            nextOwnerPlayerAction.block.coordinates,
          ),
        );
        block?.status = nextOwnerPlayerAction.status;
      }
      if (nextOpponentPlayerAction != null) {
        state.room.ownerPlayingData?.occupiedBlocks.forEach((ship) {
          ship.overlappingPositions.removeWhere(
            (ps) => ListEquality().equals(
              ps.coordinates,
              nextOpponentPlayerAction.block.coordinates,
            ),
          );
          LoggerUtils.i(ship.overlappingPositions);
        });
        final block = state.room.ownerPlayingData?.emptyBlocks.firstWhere(
          (b) => ListEquality().equals(
            b.block.coordinates,
            nextOpponentPlayerAction.block.coordinates,
          ),
        );
        block?.status = nextOpponentPlayerAction.status;
      }
      emit(state.copyWith(action: GameAction.checkSunk));
      Future.delayed(Duration(seconds: 3)).then((_){
        emit(state.copyWith(action: GameAction.nextTurn));
      });
    });
  }
}
