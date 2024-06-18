import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
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
  final OpponentPlayer? opponentPlayer;
  final GameStatus? gameStatus;
  final RoomState? roomState;
  PlayingData? ownerPlayingData;
  PlayingData? opponentPlayingData;

  RoomData({
    this.code,
    this.opponentPlayer,
    this.ownerPlayer,
    this.gameStatus,
    this.roomState,
    this.ownerPlayingData,
    this.opponentPlayingData,
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
      gameStatus: GameStatus.values.byName(data['gameStatus']),
      code: data['room_code'],
      roomState: RoomState.values.byName(data['roomState']),
      ownerPlayingData: data['ownerPlayingData'] != null
          ? PlayingData.fromJson(data['ownerPlayingData'])
          : null,
      opponentPlayingData: data['opponentPlayingData'] != null
          ? PlayingData.fromJson(data['opponentPlayingData'])
          : null,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (code != null) "room_code": code,
      if (opponentPlayer != null) "opponentPlayer": opponentPlayer?.toJson(),
      if (ownerPlayer != null) "ownerPlayer": ownerPlayer?.toJson(),
      if (gameStatus != null) "gameStatus": gameStatus?.name,
      if (roomState != null) "roomState": roomState?.name,
      if (ownerPlayingData != null)
        "ownerPlayingData": ownerPlayingData?.toJson(),
      if (opponentPlayingData != null)
        "opponentPlayingData": opponentPlayingData?.toJson(),
    };
  }

  Map<String, dynamic> opponentOutOfRoom = {
    "opponentPlayer": FieldValue.delete(),
    "roomState": RoomState.empty.name,
  };

  Map<String, dynamic> startPreparing = {
    "gameStatus": GameStatus.preparing.name,
  };

  Map<String, dynamic> playGame = {
    "gameStatus": GameStatus.started.name,
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
        (b) => emptyBlocks.add(
          EmptyBattleSquare.fromJson(b),
        ),
      );
    }

    if (json['occupiedBlocks'] != null) {
      json['occupiedBlocks'].forEach(
        (o) => occupiedBlocks.add(
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
