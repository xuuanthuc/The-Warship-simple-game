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

  const GamePlayState({
    required this.status,
    required this.emptySquares,
    required this.occupiedSquares,
    required this.action,
  });

  GamePlayState.empty()
      : this(
          action: GameAction.prepare,
          status: GameStatus.init,
          emptySquares: [],
          occupiedSquares: [],
        );

  GamePlayState copyWith({
    GameStatus? status,
    List<EmptyBattleSquare>? battles,
    List<OccupiedBattleSquare>? ships,
    GameAction? action,
  }) {
    return GamePlayState(
      status: status ?? this.status,
      emptySquares: battles ?? this.emptySquares,
      occupiedSquares: ships ?? this.occupiedSquares,
      action: action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [
        status,
        emptySquares,
        occupiedSquares,
        action,
      ];
}
