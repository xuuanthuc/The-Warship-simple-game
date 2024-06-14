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
  final List<SeaInBattle> battles;
  final List<ShipInBattle> ships;
  final GameAction action;

  const GamePlayState({
    required this.status,
    required this.battles,
    required this.ships,
    required this.action,
  });

  GamePlayState.empty()
      : this(
          action: GameAction.prepare,
          status: GameStatus.init,
          battles: [],
          ships: [],
        );

  GamePlayState copyWith({
    GameStatus? status,
    List<SeaInBattle>? battles,
    List<ShipInBattle>? ships,
    GameAction? action,
  }) {
    return GamePlayState(
      status: status ?? this.status,
      battles: battles ?? this.battles,
      ships: ships ?? this.ships,
      action: action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [
        status,
        battles,
        ships,
        action,
      ];
}
