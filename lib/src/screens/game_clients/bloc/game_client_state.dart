part of 'game_client_cubit.dart';

enum ClientAction {
  create,
  join,
  ready,
  cancel,
}

enum ClientStatus {
  success,
  loading,
  error,
}

@immutable
class GameClientState extends Equatable {
  final RoomData? room;
  final Player? player;
  final BattleshipSkin? skin;
  final ClientAction? action;
  final ClientStatus? status;
  final String? message;

  const GameClientState({
    required this.room,
    this.player,
    this.skin,
    this.action,
    this.status,
    this.message,
  });

  GameClientState copyWith({
    required RoomData? room,
    Player? player,
    BattleshipSkin? skin,
    ClientAction? action,
    ClientStatus? status,
    String? message,
  }) {
    return GameClientState(
      room: room,
      player: player ?? this.player,
      skin: skin ?? this.skin,
      action: action ?? this.action,
      status: status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
        room,
        player,
        skin,
        action,
        message,
        status,
      ];
}
