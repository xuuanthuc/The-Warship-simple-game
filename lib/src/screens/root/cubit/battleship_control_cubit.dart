import 'package:bloc/bloc.dart';
import 'package:flame/components.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'battleship_control_state.dart';

@injectable
class BattleshipControlCubit extends Cubit<BattleshipControlState> {
  BattleshipControlCubit() : super(const BattleshipControlState());

  void getReady() {}

  void addCollisionBlocks(PositionComponent object) {
    emit(state.copyWith(
      collisions: (state.collisions ?? [])..add(object),
      isPrepared: false,
    ));
  }

  void removeCollisionBlocks(PositionComponent object) {
    final collisions = state.collisions?..remove(object);
    if ((collisions ?? []).isEmpty) {
      emit(state.copyWith(
        collisions: collisions,
        isPrepared: true,
      ));
    }
  }
}
