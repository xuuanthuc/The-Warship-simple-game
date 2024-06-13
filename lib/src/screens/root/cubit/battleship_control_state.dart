part of 'battleship_control_cubit.dart';

enum GameAction {
  prepare,
  shuffle,
  ready,
}

@immutable
class BattleshipControlState extends Equatable {
  final GameStatus status;
  final List<SeaInBattle> battles;
  final List<ShipInBattle> ships;
  final GameAction action;

  const BattleshipControlState({
    required this.status,
    required this.battles,
    required this.ships,
    required this.action,
  });

  BattleshipControlState.empty()
      : this(
          action: GameAction.prepare,
          status: GameStatus.init,
          battles: [],
          ships: [],
        );

  BattleshipControlState copyWith({
    GameStatus? status,
    List<SeaInBattle>? battles,
    List<ShipInBattle>? ships,
    GameAction? action,
  }) {
    return BattleshipControlState(
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
