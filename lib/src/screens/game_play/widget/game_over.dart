import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/bloc/game_play/game_play_cubit.dart';
import 'package:template/src/style/app_images.dart';

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<GamePlayCubit>().exitGame();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.65),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<GamePlayCubit, GamePlayState>(
                buildWhen: (_, cur) => cur.action == GameAction.end,
                builder: (context, state) {
                  final room = state.room;
                  final player = state.player;
                  final hostPlayer = room.ownerPlayer;
                  final iamHost =
                      hostPlayer != null && player?.id == hostPlayer.id;

                  if (!state.room.guestPlayingData!.occupiedBlocks
                      .any((s) => s.overlappingPositions.isNotEmpty)) {
                    if (iamHost) {
                      return VictoryComponent();
                    } else {
                      return DefeatComponent();
                    }
                  }
                  if (!state.room.ownerPlayingData!.occupiedBlocks
                      .any((s) => s.overlappingPositions.isNotEmpty)) {
                    if (iamHost) {
                      return DefeatComponent();
                    } else {
                      return VictoryComponent();
                    }
                  }
                  return SizedBox.shrink();
                },
              ),
              Center(
                child: Text(
                  "Tap to continue",
                  style: TextStyle(
                    fontFamily: "Mitr",
                    fontWeight: FontWeight.w500,
                    fontSize: 26,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VictoryComponent extends StatelessWidget {
  const VictoryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.6,
        maxWidth: MediaQuery.sizeOf(context).width * 0.6,
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.6,
        width: MediaQuery.sizeOf(context).width * 0.6,
        child: Image.asset(
          AppImages.victory,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class DefeatComponent extends StatelessWidget {
  const DefeatComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.6,
        maxWidth: MediaQuery.sizeOf(context).width * 0.6,
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.6,
        width: MediaQuery.sizeOf(context).width * 0.6,
        child: Image.asset(
          AppImages.defeat,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
