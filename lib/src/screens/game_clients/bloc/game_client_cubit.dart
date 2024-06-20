import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template/src/models/player.dart';
import 'package:template/src/models/room_data.dart';
import 'package:template/src/utilities/game_data.dart';
import 'package:template/src/utilities/logger.dart';

part 'game_client_state.dart';

const _chars = 'ABCDEFGHIJKLMNPQRSTUVWXYZ123456789';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

@injectable
class GameClientCubit extends Cubit<GameClientState> {
  GameClientCubit()
      : super(const GameClientState(
          room: null,
          skin: BattleshipSkin.A,
        ));

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _roomStream;
  final firebase = FirebaseFirestore.instance;

  void createNewRoom({
    required GameStatus status,
    required OwnerPlayer player,
  }) {
    final newCodeGenerated = getRandomString(6);

    final room = RoomData(
      code: newCodeGenerated,
      ownerPlayer: player,
      gameStatus: GameStatus.loading,
      roomState: RoomState.empty,
    );

    firebase
        .collection("rooms")
        .doc(newCodeGenerated)
        .set(room.toFireStore(), SetOptions(merge: true))
        .then((value) {
      setRoomDataStreamSubscription(newCodeGenerated, player);
    });
  }

  void guestReady() {
    if (state.room?.guestPlayer?.readyForGame == null) return;
    firebase
        .collection("rooms")
        .doc(state.room?.code)
        .update(state.room!.guestPlayer!.readyForGame());
  }

  void deleteRoom() {
    LoggerUtils.i("Delete Room");
    firebase.collection("rooms").doc(state.room?.code).delete().then((value) {
      removeRoomDataStreamSubscription();
    });
  }

  void outRoom() {
    LoggerUtils.i("Out room");
    firebase
        .collection("rooms")
        .doc(state.room?.code)
        .update(state.room!.guestOutOfRoom)
        .then((value) {
      removeRoomDataStreamSubscription();
    });
  }

  void setRoomDataStreamSubscription(
    String code,
    Player player,
  ) {
    _roomStream =
        firebase.collection("rooms").doc(code).snapshots().listen((roomData) {
      emit(state.copyWith(
        room: roomData.data() != null ? RoomData.fromFireStore(roomData) : null,
        player: player,
      ));
    });
  }

  void removeRoomDataStreamSubscription() {
    emit(state.copyWith(room: null));
    _roomStream?.cancel();
    _roomStream = null;
  }

  void joinRoom({
    required GuestPlayer player,
    required String code,
  }) {
    final room = RoomData(
      code: code.toUpperCase(),
      guestPlayer: player,
      roomState: RoomState.full,
    );

    firebase.collection("rooms").doc(code.toUpperCase()).get().then((value) {
      if (value.exists) {
        final roomData = RoomData.fromFireStore(value);
        if (roomData.roomState == RoomState.full) {
          LoggerUtils.i("Fullll");
          return;
        }
        firebase
            .collection("rooms")
            .doc(code.toUpperCase())
            .set(room.toFireStore(), SetOptions(merge: true))
            .then((onValue) {
          setRoomDataStreamSubscription(code.toUpperCase(), player);
        });
      } else {
        LoggerUtils.i("Rooom not exists");
      }
    }).onError((error, s) {
      LoggerUtils.e(error.toString());
    });
  }

  void start() {
    firebase
        .collection("rooms")
        .doc(state.room?.code)
        .update(state.room!.startPreparing);
  }

  void setSkin(BattleshipSkin skin) {
    GameData.instance.setOccupiedSkin(skin);
    emit(state.copyWith(room: state.room, skin: skin));
  }

  @override
  Future<void> close() {
    removeRoomDataStreamSubscription();
    return super.close();
  }
}
