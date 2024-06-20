import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/bloc/game_play/game_play_cubit.dart';
import 'package:template/src/screens/game_clients/bloc/game_client_cubit.dart';
import 'package:template/src/style/app_colors.dart';
import 'package:template/src/style/app_images.dart';
import 'package:template/src/utilities/game_data.dart';
import 'package:template/src/utilities/toast.dart';

import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameClientCubit, GameClientState>(
      builder: (context, state) {
        final currentPlayer = state.player;
        final hostPlayer = state.room?.ownerPlayer;
        final iamHost = currentPlayer != null &&
            hostPlayer != null &&
            currentPlayer.id == hostPlayer.id;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SecondaryButton.icon(
                  onPressed: () {
                    if (iamHost) {
                      context.read<GameClientCubit>().deleteRoom();
                    } else {
                      context.read<GameClientCubit>().outRoom();
                    }
                  },
                  icon: AppImages.arrowBack,
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text("Waiting the opponent..."),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
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
                    Text(iamHost ? "You" : "Opponent")
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      color: Colors.red,
                      child: Text(
                        state.room?.guestPlayer?.id ?? 'Player 2',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(iamHost ? "Opponent" : "You")
                  ],
                ),
              ],
            ),
            Text("Select your skin"),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: 300,
              child: Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    height: 300,
                    child: Image.asset(
                      "assets/images/${AppImages.background}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Image.asset(
                        state.skin == BattleshipSkin.A
                            ? "assets/images/${AppImages.previewA}"
                            : "assets/images/${AppImages.previewB}",
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<GameClientCubit>().setSkin(BattleshipSkin.A);
                  },
                  child: Text("Skin A"),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<GameClientCubit>().setSkin(BattleshipSkin.B);
                  },
                  child: Text("Skin B"),
                ),
              ],
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PrimaryButton.secondary(
                  onPressed: () async {
                    if((state.room?.code ?? "").isEmpty) return;
                    await Clipboard.setData(ClipboardData(text: state.room!.code!));
                    if(context.mounted){
                      appToast(context, message: "Copied to clipboard!");
                    }
                  },
                  text:"${state.room?.code ?? ''}  ❐",
                  fontSize: 24,
                  background: AppColors.gray,
                  underground: AppColors.grayDark,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                ),
                const SizedBox(width: 30),
                PrimaryButton.primary(
                  onPressed: () async {
                    final room = state.room;
                    final player = state.player;
                    if (room == null || player == null) return;
                    context
                        .read<GamePlayCubit>()
                        .getRoomDataToPrepareBattleGame(room, player);
                    await Future.delayed(const Duration(milliseconds: 300));
                    if (iamHost) {
                      if (room.guestPlayer?.ready == true) {
                        if (context.mounted) {
                          context.read<GameClientCubit>().start();
                        }
                      } else {
                        print("opponent not Ready game");
                      }
                    } else {
                      context.read<GameClientCubit>().guestReady();
                    }
                  },
                  text: iamHost
                      ? "START"
                      : state.room?.guestPlayer?.ready == true
                          ? "CANCEL"
                          : "READY",
                  fontSize: 30,
                  padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
