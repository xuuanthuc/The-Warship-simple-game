part of 'game_play_cubit.dart';

enum GameAction {
  prepare,
  shuffle,
  ready,
  checkHit,
  checkSunk,
  shoot,
}

@immutable
class GamePlayState extends Equatable {
  final GameStatus status;
  final List<EmptyBattleSquare> emptySquares;
  final List<OccupiedBattleSquare> occupiedSquares;
  final GameAction action;
  final RoomData? room;
  final Player? player;

  const GamePlayState({
    required this.status,
    required this.emptySquares,
    required this.occupiedSquares,
    required this.action,
    required this.room,
    required this.player,
  });

  GamePlayState.empty()
      : this(
          action: GameAction.prepare,
          status: GameStatus.init,
          emptySquares: [],
          occupiedSquares: [],
          room: null,
          player: null,
        );

  GamePlayState copyWith({
    GameStatus? status,
    List<EmptyBattleSquare>? battles,
    List<OccupiedBattleSquare>? ships,
    GameAction? action,
    RoomData? room,
    Player? player,
  }) {
    return GamePlayState(
      status: status ?? this.status,
      emptySquares: battles ?? this.emptySquares,
      occupiedSquares: ships ?? this.occupiedSquares,
      action: action ?? this.action,
      room: room ?? this.room,
      player: player ?? this.player,
    );
  }

  @override
  List<Object?> get props => [
        status,
        emptySquares,
        occupiedSquares,
        action,
        room,
        player,
      ];
}
