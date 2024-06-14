import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'game_client_state.dart';

class GameClientCubit extends Cubit<GameClientState> {
  GameClientCubit() : super(GameClientInitial());
}
