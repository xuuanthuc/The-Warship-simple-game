import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/screens/game_clients/bloc/game_client_cubit.dart';
import 'package:template/src/screens/game_clients/lobby_screen.dart';
import 'package:template/src/screens/game_clients/room_screen.dart';

class GameClientScreen extends StatelessWidget {
  const GameClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GameClientCubit, GameClientState>(
        builder: (context, state) {
          if(state.room != null){
            return RoomScreen();
          }
          return LobbyScreen();
        },
      ),
    );
  }
}
