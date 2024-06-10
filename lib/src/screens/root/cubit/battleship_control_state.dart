part of 'battleship_control_cubit.dart';

@immutable
class BattleshipControlState {
  final Battleship? focused;

  const BattleshipControlState({this.focused});

  BattleshipControlState copyWith({Battleship? focused}) {
    return BattleshipControlState(focused: focused ?? this.focused);
  }
}
