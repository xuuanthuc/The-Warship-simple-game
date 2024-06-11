part of 'battleship_control_cubit.dart';

@immutable
class BattleshipControlState {
  final bool? isPrepared;
  final List<PositionComponent>? collisions;

  const BattleshipControlState({
    this.isPrepared,
    this.collisions,
  });

  BattleshipControlState copyWith({bool? isPrepared, List<PositionComponent>? collisions}) {
    return BattleshipControlState(
      isPrepared: isPrepared ?? this.isPrepared,
      collisions: collisions ?? this.collisions,
    );
  }
}
