import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class Player {
  String? id;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  ConnectivityResult? connectivityResult;
  bool? ready;

  Player({
    required this.id,
    this.connectivityResult,
    this.createdAt,
    this.ready,
    this.updatedAt,
  });

  Player.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ready = json['ready'];
    createdAt = json["createdAt"];
    updatedAt = json["updatedAt"];
    connectivityResult = getConnectivityResult(json["connectionStatus"]);
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "id": id,
      if (ready != null) "ready": ready,
      if (createdAt != null) "createdAt": createdAt,
      if (updatedAt != null) "updatedAt": updatedAt,
      if (connectivityResult != null)
        "connectionStatus": connectivityResult?.name,
    };
  }
}

ConnectivityResult getConnectivityResult(String name) {
  switch (name) {
    case "none":
      return ConnectivityResult.none;
    case "wifi":
      return ConnectivityResult.wifi;
    case "mobile":
      return ConnectivityResult.mobile;
    case "ethernet":
      return ConnectivityResult.ethernet;
    case "bluetooth":
      return ConnectivityResult.bluetooth;
    case "vpn":
      return ConnectivityResult.vpn;
    case "other":
      return ConnectivityResult.other;
    default:
      return ConnectivityResult.none;
  }
}

class OwnerPlayer extends Player {
  OwnerPlayer.fromJson(super.json) : super.fromJson();

  OwnerPlayer({
    required String id,
    ConnectivityResult? connectivityResult,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    bool? ready,
  }) : super(
          id: id,
          connectivityResult: connectivityResult,
          createdAt: createdAt,
          updatedAt: updatedAt,
          ready: ready,
        );
}

class OpponentPlayer extends Player {
  OpponentPlayer.fromJson(super.json) : super.fromJson();

  OpponentPlayer({
    required String id,
    ConnectivityResult? connectivityResult,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    bool? ready,
  }) : super(
          id: id,
          connectivityResult: connectivityResult,
          createdAt: createdAt,
          updatedAt: updatedAt,
          ready: ready,
        );

  Map<String, dynamic> readyForGame() {
    return {
      "opponentPlayer.ready": !(ready ?? false),
    };
  }
}
