import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/routes/navigation_service.dart';
import 'package:template/src/routes/route_keys.dart';
import 'package:template/src/screens/game_clients/bloc/game_client_cubit.dart';
import 'package:template/src/screens/game_clients/lobby_screen.dart';
import 'package:template/src/screens/game_clients/room_screen.dart';
import 'package:template/src/utilities/game_data.dart';

class GameClientScreen extends StatelessWidget {
  const GameClientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<GameClientCubit, GameClientState>(
        listener: (context, state) {
          if(state.room?.gameStatus == GameStatus.preparing){
            context.read<GameClientCubit>().close();
            navService.pushReplacementNamed(RouteKey.gamePlay);
          }
        },
        child: BlocBuilder<GameClientCubit, GameClientState>(
          builder: (context, state) {
            if (state.room != null) {
              return RoomScreen();
            }
            return LobbyScreen();
          },
        ),
      ),
    );
  }
}
