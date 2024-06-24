import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:template/src/utilities/game_data.dart';

abstract class Player {
  String? id;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  ConnectivityResult? connectivityResult;
  BattleshipSkin? skin;
  bool? ready;

  Player({
    required this.id,
    this.connectivityResult,
    this.createdAt,
    this.ready,
    this.updatedAt,
    this.skin,
  });

  Player.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ready = json['ready'];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    skin = BattleshipSkin.values.byName(json["skin"]);
    connectivityResult =
        ConnectivityResult.values.byName(json["connectionStatus"]);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      if (ready != null) "ready": ready,
      if (createdAt != null) "createdAt": createdAt,
      if (skin != null) "skin": skin?.name,
      if (updatedAt != null) "updatedAt": updatedAt,
      if (connectivityResult != null)
        "connectionStatus": connectivityResult?.name,
    };
  }
}

class OwnerPlayer extends Player {
  OwnerPlayer.fromJson(super.json) : super.fromJson();

  OwnerPlayer({
    required String id,
    ConnectivityResult? connectivityResult,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    BattleshipSkin? skin,
    bool? ready,
  }) : super(
          id: id,
          connectivityResult: connectivityResult,
          createdAt: createdAt,
          updatedAt: updatedAt,
          skin: skin,
          ready: ready,
        );
}

class GuestPlayer extends Player {
  GuestPlayer.fromJson(super.json) : super.fromJson();

  GuestPlayer({
    required String id,
    ConnectivityResult? connectivityResult,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    BattleshipSkin? skin,
    bool? ready,
  }) : super(
          id: id,
          connectivityResult: connectivityResult,
          createdAt: createdAt,
          updatedAt: updatedAt,
          skin: skin,
          ready: ready,
        );

  Map<String, dynamic> readyForGame() {
    return {
      "guestPlayer.ready": !(ready ?? false),
    };
  }
}
