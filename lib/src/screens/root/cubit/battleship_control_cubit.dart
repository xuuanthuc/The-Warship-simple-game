import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:template/src/models/battleship.dart';

part 'battleship_control_state.dart';

@injectable
class BattleshipControlCubit extends Cubit<BattleshipControlState> {
  BattleshipControlCubit() : super(const BattleshipControlState());

  onRotateBattleship() {
    final battleship = state.focused;
    battleship?.symmetric =
        battleship.symmetric == BattleshipSymmetric.horizontal
            ? BattleshipSymmetric.vertical
            : BattleshipSymmetric.horizontal;
    emit(BattleshipControlState(focused: battleship));
  }

  onFocusBattleship(Battleship battleship) {
    emit(BattleshipControlState(focused: battleship));
  }
}
