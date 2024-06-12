part of 'battleship_control_cubit.dart';

enum GameAction {
  prepare,
  shuffle,
  ready,
}

@immutable
class BattleshipControlState extends Equatable {
  final GameStatus status;
  final List<Battle> battles;
  final GameAction action;

  const BattleshipControlState({
    required this.status,
    required this.battles,
    required this.action,
  });

  BattleshipControlState.empty()
      : this(
          action: GameAction.prepare,
          status: GameStatus.prepare,
          battles: [],
        );

  BattleshipControlState copyWith(
      {GameStatus? status, List<Battle>? battles, GameAction? action}) {
    return BattleshipControlState(
      status: status ?? this.status,
      battles: battles ?? this.battles,
      action: action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [
        status,
        battles,
        action,
      ];
}
