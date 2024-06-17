import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/screens/game_clients/bloc/game_client_cubit.dart';
import 'package:template/src/utilities/game_data.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameClientCubit, GameClientState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text("Waiting the opponent..."),
              ],
            ),
            Text(state.room?.code ?? ''),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.cyan,
                  child: Text(
                    state.room?.ownerPlayer?.id ?? 'Player 1',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                  child: Text(
                    state.room?.opponentPlayer?.id ?? 'Player 2',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                final currentPlayer = state.player;
                final hostPlayer = state.room?.ownerPlayer;
                if (currentPlayer != null &&
                    hostPlayer != null &&
                    currentPlayer.id == hostPlayer.id) {
                  context.read<GameClientCubit>().deleteRoom();
                } else {
                  context.read<GameClientCubit>().outRoom();
                }
              },
              child: Text("Exit room"),
            )
          ],
        );
      },
    );
  }
}
