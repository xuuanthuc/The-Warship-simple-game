import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/bloc/game_play/game_play_cubit.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: BlocBuilder<GamePlayCubit, GamePlayState>(
        builder: (context, state) {
          final room = state.room;
          final player = state.player;
          final hostPlayer = room.ownerPlayer;
          final iamHost = hostPlayer != null && player?.id == hostPlayer.id;

          if (!state.room.guestPlayingData!.occupiedBlocks
              .any((s) => s.overlappingPositions.isNotEmpty)) {
            return Text(
              iamHost ? "Game over: Owner win" : "You lost",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w700,
                color: Colors.blue,
              ),
            );
          }
          if (!state.room.ownerPlayingData!.occupiedBlocks
              .any((s) => s.overlappingPositions.isNotEmpty)) {
            return Text(
              iamHost ? "You lost" : "Game over: Guest win",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w700,
                color: Colors.blue,
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
