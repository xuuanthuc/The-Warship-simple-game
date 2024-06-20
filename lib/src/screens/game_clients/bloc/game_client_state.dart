part of 'game_client_cubit.dart';

@immutable
class GameClientState extends Equatable {
  final RoomData? room;
  final Player? player;
  final BattleshipSkin? skin;

  const GameClientState({
    required this.room,
    this.player,
    this.skin,
  });

  GameClientState copyWith({
    required RoomData? room,
    Player? player,
    BattleshipSkin? skin,
  }) {
    return GameClientState(
      room: room,
      player: player ?? this.player,
      skin: skin ?? this.skin,
    );
  }

  @override
  List<Object?> get props => [
        room,
        player,
        skin,
      ];
}
