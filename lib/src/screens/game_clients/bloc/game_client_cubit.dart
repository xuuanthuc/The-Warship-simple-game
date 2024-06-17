import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template/src/models/player.dart';
import 'package:template/src/models/room_data.dart';
import 'package:template/src/utilities/game_data.dart';
import 'package:template/src/utilities/logger.dart';

part 'game_client_state.dart';

const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

@injectable
class GameClientCubit extends Cubit<GameClientState> {
  GameClientCubit() : super(GameClientState(room: null));

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _roomStream;

  void createNewRoom({
    required GameStatus status,
    required OwnerPlayer player,
  }) {
    final db = FirebaseFirestore.instance;
    final newCodeGenerated = getRandomString(6);

    final room = RoomData(
      opponentPlayer: null,
      code: newCodeGenerated,
      ownerPlayer: player,
      gameStatus: GameStatus.loading,
      roomState: RoomState.empty,
    );

    db
        .collection("rooms")
        .doc(newCodeGenerated)
        .set(room.toFireStore(), SetOptions(merge: true))
        .then((value) {
      setRoomDataStreamSubscription(newCodeGenerated, player);
    });
  }

  void deleteRoom() {
    final db = FirebaseFirestore.instance;
    LoggerUtils.i("Delete Room");
    db.collection("rooms").doc(state.room?.code).delete().then((value) {
      removeRoomDataStreamSubscription();
    });
  }

  void outRoom() {
    final db = FirebaseFirestore.instance;
    LoggerUtils.i("Out room");
    db
        .collection("rooms")
        .doc(state.room?.code)
        .update(state.room!.opponentOutOfRoom)
        .then((value) {
      removeRoomDataStreamSubscription();
    });
  }

  void setRoomDataStreamSubscription(
    String code,
    Player player,
  ) {
    final db = FirebaseFirestore.instance;
    _roomStream =
        db.collection("rooms").doc(code).snapshots().listen((roomData) {
      emit(state.copyWith(
        room: roomData.data() != null ? RoomData.fromFireStore(roomData) : null,
        player: player,
      ));
    });
  }

  void removeRoomDataStreamSubscription() {
    _roomStream?.cancel();
    _roomStream = null;
    emit(state.copyWith(room: null));
  }

  void joinRoom({
    required OpponentPlayer player,
    required String code,
  }) {
    final db = FirebaseFirestore.instance;

    final room = RoomData(
      code: code,
      opponentPlayer: player,
      ownerPlayer: null,
      gameStatus: GameStatus.loaded,
      roomState: RoomState.full,
    );

    db.collection("rooms").doc(code).get().then((value) {
      if (value.exists) {
        final roomData = RoomData.fromFireStore(value);
        if (roomData.roomState == RoomState.full) {
          LoggerUtils.i("Fullll");
          return;
        }
        db
            .collection("rooms")
            .doc(code)
            .set(room.toFireStore(), SetOptions(merge: true))
            .then((onValue) {
          setRoomDataStreamSubscription(code, player);
        });
      } else {
        LoggerUtils.i("Rooom not exists");
      }
    }).onError((error, s) {
      LoggerUtils.e(error.toString());
    });
  }
}
