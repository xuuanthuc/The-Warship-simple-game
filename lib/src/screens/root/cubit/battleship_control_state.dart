part of 'battleship_control_cubit.dart';

@immutable
class BattleshipControlState extends Equatable {
  final GameStatus status;

  const BattleshipControlState({
    required this.status,
  });

  const BattleshipControlState.empty()
      : this(
          status: GameStatus.prepare,
        );

  BattleshipControlState copyWith({
    GameStatus? status,
  }) {
    return BattleshipControlState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        status,
      ];
}
