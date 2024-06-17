import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template/src/models/player.dart';
import 'package:template/src/utilities/game_data.dart';

enum RoomState {
  empty,
  full,
}

class RoomData {
  final String? code;
  final OwnerPlayer? ownerPlayer;
  final OpponentPlayer? opponentPlayer;
  final GameStatus? gameStatus;
  final RoomState? roomState;

  RoomData({
    required this.code,
    required this.opponentPlayer,
    required this.ownerPlayer,
    required this.gameStatus,
    required this.roomState,
  });

  factory RoomData.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() as Map<String, dynamic>;
    return RoomData(
      opponentPlayer: data['opponentPlayer'] != null
          ? OpponentPlayer.fromJson(data['opponentPlayer'])
          : null,
      ownerPlayer: data['ownerPlayer'] != null
          ? OwnerPlayer.fromJson(data['ownerPlayer'])
          : null,
      gameStatus: getGameStatus(data['gameStatus']),
      code: data['room_code'],
      roomState: getRoomState(data['roomState']),
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (code != null) "room_code": code,
      if (opponentPlayer != null) "opponentPlayer": opponentPlayer?.toJson(),
      if (ownerPlayer != null) "ownerPlayer": ownerPlayer?.toJson(),
      if (gameStatus != null) "gameStatus": gameStatus?.name,
      if (roomState != null) "roomState": roomState?.name,
    };
  }

  Map<String, dynamic> opponentOutOfRoom = {
    "opponentPlayer": FieldValue.delete(),
    "gameStatus": GameStatus.loading.name,
    "roomState": RoomState.empty.name,
  };
}

GameStatus getGameStatus(String name) {
  switch (name) {
    case "init":
      return GameStatus.init;
    case "loading":
      return GameStatus.loading;
    case "loaded":
      return GameStatus.loaded;
    case "preparing":
      return GameStatus.preparing;
    case "prepared":
      return GameStatus.prepared;
    case "ready":
      return GameStatus.ready;
    case "started":
      return GameStatus.started;
    case "playing":
      return GameStatus.playing;
    case "paused":
      return GameStatus.paused;
    case "resumed":
      return GameStatus.resumed;
    case "finished":
      return GameStatus.finished;
    case "error":
    default:
      return GameStatus.error;
  }
}

RoomState getRoomState(String name) {
  switch (name) {
    case "empty":
      return RoomState.empty;
    case "full":
      return RoomState.full;
    default:
      return RoomState.full;
  }
}
