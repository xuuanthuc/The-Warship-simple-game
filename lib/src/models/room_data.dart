import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template/src/models/player.dart';
import 'package:template/src/utilities/game_data.dart';
import 'battle.dart';

enum RoomState {
  empty,
  full;
}

class RoomData {
  final String? code;
  final OwnerPlayer? ownerPlayer;
  final GuestPlayer? guestPlayer;
  final GameStatus? gameStatus;
  final RoomState? roomState;
  PlayingData? ownerPlayingData;
  PlayingData? guestPlayingData;
  final EmptyBattleSquare? nextOwnerPlayerAction;
  final EmptyBattleSquare? nextGuestPlayerAction;
  Player? nextPlayer;

  RoomData({
    this.code,
    this.guestPlayer,
    this.ownerPlayer,
    this.gameStatus,
    this.roomState,
    this.ownerPlayingData,
    this.guestPlayingData,
    this.nextGuestPlayerAction,
    this.nextOwnerPlayerAction,
    this.nextPlayer,
  });

  factory RoomData.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,) {
    final data = snapshot.data() as Map<String, dynamic>;
    return RoomData(
      guestPlayer: data['guestPlayer'] != null
          ? GuestPlayer.fromJson(data['guestPlayer'])
          : null,
      ownerPlayer: data['ownerPlayer'] != null
          ? OwnerPlayer.fromJson(data['ownerPlayer'])
          : null,
      gameStatus: GameStatus.values.byName(data['gameStatus']),
      code: data['room_code'],
      roomState: RoomState.values.byName(data['roomState']),
      ownerPlayingData: data['ownerPlayingData'] != null
          ? PlayingData.fromJson(data['ownerPlayingData'])
          : null,
      guestPlayingData: data['guestPlayingData'] != null
          ? PlayingData.fromJson(data['guestPlayingData'])
          : null,
      nextOwnerPlayerAction: data['nextOwnerPlayerAction'] != null
          ? EmptyBattleSquare.fromJson(data['nextOwnerPlayerAction'])
          : null,
      nextGuestPlayerAction: data['nextGuestPlayerAction'] != null
          ? EmptyBattleSquare.fromJson(data['nextGuestPlayerAction'])
          : null,
      nextPlayer: data['nextPlayer'] != null
          ? OwnerPlayer.fromJson(data['nextPlayer'])
          : null,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (code != null) "room_code": code,
      if (guestPlayer != null) "guestPlayer": guestPlayer?.toJson(),
      if (ownerPlayer != null) "ownerPlayer": ownerPlayer?.toJson(),
      if (gameStatus != null) "gameStatus": gameStatus?.name,
      if (roomState != null) "roomState": roomState?.name,
      if (ownerPlayingData != null)
        "ownerPlayingData": ownerPlayingData?.toJson(),
      if (guestPlayingData != null)
        "guestPlayingData": guestPlayingData?.toJson(),
      if (nextOwnerPlayerAction != null)
        "nextOwnerPlayerAction": nextOwnerPlayerAction?.toJson(),
      if (nextGuestPlayerAction != null)
        "nextGuestPlayerAction": nextGuestPlayerAction?.toJson(),
      if (nextPlayer != null) "nextPlayer": nextPlayer?.toJson(),
    };
  }

  Map<String, dynamic> guestOutOfRoom = {
    "guestPlayer": FieldValue.delete(),
    "roomState": RoomState.empty.name,
  };

  Map<String, dynamic> guestSkinSelected(BattleshipSkin skin) {
    return {"guestPlayer.skin": skin.name};
  }

  Map<String, dynamic> ownerSkinSelected(BattleshipSkin skin) {
    return {"ownerPlayer.skin": skin.name};
  }

  Map<String, dynamic> startPreparing = {
    "gameStatus": GameStatus.preparing.name,
  };

  Map<String, dynamic> playGame(Player firstTurn) =>
      {
        "gameStatus": GameStatus.started.name,
        "nextPlayer": firstTurn.toJson(),
      };

  Map<String, dynamic> actionOfOwnerPlayer(EmptyBattleSquare square,
      Player? player) =>
      {
        "nextOwnerPlayerAction": square.toJson(),
        "guestPlayingData": guestPlayingData?.toJson(),
        "nextGuestPlayerAction": null,
        if (player != null) "nextPlayer": player.toJson(),
      };

  Map<String, dynamic> actionOfOccupiedPlayer(EmptyBattleSquare square,
      Player? player) =>
      {
        "nextGuestPlayerAction": square.toJson(),
        "ownerPlayingData": ownerPlayingData?.toJson(),
        "nextOwnerPlayerAction": null,
        if (player != null) "nextPlayer": player.toJson(),
      };
}

class PlayingData {
  final List<EmptyBattleSquare> emptyBlocks;
  final List<OccupiedBattleSquare> occupiedBlocks;

  PlayingData({
    required this.emptyBlocks,
    required this.occupiedBlocks,
  });

  factory PlayingData.fromJson(Map<String, dynamic> json) {
    final List<EmptyBattleSquare> emptyBlocks = [];
    final List<OccupiedBattleSquare> occupiedBlocks = [];
    if (json['emptyBlocks'] != null) {
      json['emptyBlocks'].forEach(
            (b) =>
            emptyBlocks.add(
              EmptyBattleSquare.fromJson(b),
            ),
      );
    }

    if (json['occupiedBlocks'] != null) {
      json['occupiedBlocks'].forEach(
            (o) =>
            occupiedBlocks.add(
              OccupiedBattleSquare.fromJson(o),
            ),
      );
    }

    return PlayingData(
      emptyBlocks: emptyBlocks,
      occupiedBlocks: occupiedBlocks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "emptyBlocks": emptyBlocks.map((e) => e.toJson()).toList(),
      "occupiedBlocks": occupiedBlocks.map((e) => e.toFireStore()).toList(),
    };
  }
}
