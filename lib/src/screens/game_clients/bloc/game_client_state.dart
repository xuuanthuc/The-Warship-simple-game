part of 'game_client_cubit.dart';

@immutable
class GameClientState extends Equatable {
  final RoomData? room;
  final Player? player;

  const GameClientState({
    required this.room,
    this.player,
  });

  GameClientState copyWith({
    required RoomData? room,
    Player? player,
  }) {
    return GameClientState(
      room: room,
      player: player ?? this.player,
    );
  }

  @override
  List<Object?> get props => [
        room,
        player,
      ];
}
